package fr.uga.pddl4j.yasp;

import fr.uga.pddl4j.plan.Plan;
import fr.uga.pddl4j.plan.SequentialPlan;
import fr.uga.pddl4j.problem.Fluent;
import fr.uga.pddl4j.problem.Problem;
import fr.uga.pddl4j.problem.operator.Action;
import fr.uga.pddl4j.problem.operator.Condition;
import fr.uga.pddl4j.problem.operator.Effect;
import fr.uga.pddl4j.util.BitVector;

import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * This class implements a planning problem/domain encoding into DIMACS
 *
 * @author H. Fiorino
 * @version 0.1 - 30.03.2024
 */
public final class SATEncoding {
    /*
     * A SAT problem in dimacs format is a list of int list a.k.a clauses
     */
    private List<List<Integer>> initList = new ArrayList<List<Integer>>();

    /*
     * Goal
     */
    private List<Integer> goalList = new ArrayList<Integer>();

    /*
     * Actions
     */
    private List<List<Integer>> actionPreconditionList = new ArrayList<List<Integer>>();
    private List<List<Integer>> actionEffectList = new ArrayList<List<Integer>>();

    /*
     * State transistions
     */
    private HashMap<Integer, List<Integer>> addList = new HashMap<Integer, List<Integer>>();
    private HashMap<Integer, List<Integer>> delList = new HashMap<Integer, List<Integer>>();
    private List<List<Integer>> stateTransitionList = new ArrayList<List<Integer>>();

    /*
     * Action disjunctions
     */
    private List<List<Integer>> actionDisjunctionList = new ArrayList<List<Integer>>();

    /*
     * Current DIMACS encoding of the planning domain and problem for #steps steps
     * Contains the initial state, actions and action disjunction
     * Goal is no there!
     */
    public List<List<Integer>> currentDimacs = new ArrayList<List<Integer>>();

    /*
     * Current goal encoding
     */
    public List<Integer> currentGoal = new ArrayList<Integer>();

    /*
     * Current number of steps of the SAT encoding
     */
    private int steps;
    private final Problem problem;

    public SATEncoding(Problem problem, int steps) {
        this.problem = problem;
        this.steps = steps;

        // Encoding of init
        // Each fact is a unit clause
        // Init state step is 1
        // We get the initial state from the planning problem
        // State is a bit vector where the ith bit at 1 corresponds to the ith fluent being true
        final int nb_fluents = problem.getFluents().size();
        //System.out.println(" fluents = " + nb_fluents );
        final BitVector init = problem.getInitialState().getPositiveFluents();
        System.out.println("problem init clauses indexes: " + init);
        for (int i = 0; i < nb_fluents; i++) {
            if (init.get(i)) {
                initList.add(List.of(pair(i + 1, 1)));
            }
        }

        BitVector goalPos = problem.getGoal().getPositiveFluents();
        BitVector goalNeg = problem.getGoal().getNegativeFluents();
        for (int i = 0; i < nb_fluents; i++) {
            if (goalPos.get(i)) {
                goalList.add(pair(i + 1, steps));
            }
            if (goalNeg.get(i)) {
                goalList.add(-pair(i + 1, steps));
            }
        }

        // DEBUG //
        Map<Integer,String> idx2name = new HashMap<>();
        for (int i = 0; i < nb_fluents; i++) {
            idx2name.put(i + 1, problem.getFluents().get(i).toString());
        }
        System.out.println("fluent map:");
        idx2name.forEach((idx, name) -> System.out.println(idx + " -> " + name));

        System.out.println("init clauses:");
        for (List<Integer> clause : initList) {
            System.out.println(clause);
        }
        // DEBUG //

        // Makes DIMACS encoding from 1 to steps
        encode(1, steps);
    }

    /*
     * SAT encoding for next step
     */
    public void next() {
        this.steps++;
        encode(this.steps, this.steps);
    }

    public String toString(final List<Integer> clause, final Problem problem) {
        final int nb_fluents = problem.getFluents().size();
        List<Integer> dejavu = new ArrayList<Integer>();
        String t = "[";
        String u = "";
        int tmp = 1;
        int [] couple;
        int bitnum;
        int step;
        for (Integer x : clause) {
            if (x > 0) {
                couple = unpair(x);
                bitnum = couple[0];
                step = couple[1];
            } else {
                couple = unpair(- x);
                bitnum = - couple[0];
                step = couple[1];
            }
            t = t + "(" + bitnum + ", " + step + ")";
            t = (tmp == clause.size()) ? t + "]\n" : t + " + ";
            tmp++;
            final int b = Math.abs(bitnum);
            if (!dejavu.contains(b)) {
                dejavu.add(b);
                u = u + b + " >> ";
                if (nb_fluents >= b) {
                    Fluent fluent = problem.getFluents().get(b - 1);
                    u = u + problem.toString(fluent)  + "\n";
                } else {
                    u = u + problem.toShortString(problem.getActions().get(b - nb_fluents - 1)) + "\n";
                }
            }
        }
        return t + u;
    }

    public Plan extractPlan(final int[] solution, final Problem problem) {
        Plan plan = new SequentialPlan();
        HashMap<Integer, Action> sequence = new HashMap<Integer, Action>();
        final int nb_fluents = problem.getFluents().size();
        int[] couple;
        int bitnum;
        int step;
        for (Integer x : solution) {
            if (x > 0) {
                couple = unpair(x);
                bitnum = couple[0];
            } else {
                couple = unpair(-x);
                bitnum = -couple[0];
            }
            step = couple[1];
            // This is a positive (asserted) action
            if (bitnum > nb_fluents) {
                final Action action = problem.getActions().get(bitnum - nb_fluents - 1);
                sequence.put(step, action);
            }
        }
        for (int s = sequence.keySet().size(); s > 0 ; s--) {
            plan.add(0, sequence.get(s));
        }
        return plan;
    }
    
    // Cantor paring function generates unique numbers
    private static int pair(int num, int step) {
        return (int) (0.5 * (num + step) * (num + step + 1) + step);
    }

    private static int[] unpair(int z) {
        /*
        Cantor unpair function is the reverse of the pairing function. It takes a single input
        and returns the two corespoding values.
        */
        int t = (int) (Math.floor((Math.sqrt(8 * z + 1) - 1) / 2));
        int bitnum = t * (t + 3) / 2 - z;
        int step = z - t * (t + 1) / 2;
        return new int[]{bitnum, step}; //Returning an array containing the two numbers
    }

    private void encode(int from, int to) {
        this.currentDimacs.clear();

        // initial state
        if (from == 1) {
            this.currentDimacs.addAll(this.initList);
        }

        final int nb_fluents = this.problem.getFluents().size();
        List<Action> actions = this.problem.getActions();

        for (int t = from; t <= to; t++) {
            // reset lists
            this.actionPreconditionList.clear();
            this.actionEffectList.clear();
            this.actionDisjunctionList.clear();
            this.addList.clear();
            this.delList.clear();
            this.stateTransitionList.clear();

            // action clauses
            for (int a = 0; a < actions.size(); a++) {
                Action action = actions.get(a);
                int actionLit = pair(nb_fluents + a + 1, t);

                // preconditions
                Condition pre = action.getPrecondition();
                BitVector posPre = pre.getPositiveFluents();
                BitVector negPre = pre.getNegativeFluents();
                for (int i = 0; i < nb_fluents; i++) {
                    if (posPre.get(i)) {
                        actionPreconditionList.add(List.of(-actionLit, pair(i + 1, t)));
                    }
                    if (negPre.get(i)) {
                        actionPreconditionList.add(List.of(-actionLit, -pair(i + 1, t)));
                    }
                }

                // effects
                Effect eff = action.getUnconditionalEffect();
                BitVector posEff = eff.getPositiveFluents();
                BitVector negEff = eff.getNegativeFluents();
                for (int i = 0; i < nb_fluents; i++) {
                    if (posEff.get(i)) {
                        actionEffectList.add(List.of(-actionLit, pair(i + 1, t + 1)));
                        addList.computeIfAbsent(pair(i + 1, t + 1), k -> new ArrayList<>()).add(actionLit);
                    }
                    if (negEff.get(i)) {
                        actionEffectList.add(List.of(-actionLit, -pair(i + 1, t + 1)));
                        delList.computeIfAbsent(pair(i + 1, t + 1), k -> new ArrayList<>()).add(actionLit);
                    }
                }

                // exclusive action
                actionDisjunctionList.add(List.of(actionLit));
            }

            // frame axioms
            if (t < to) {
                for (int i = 0; i < nb_fluents; i++) {
                    int varT  = pair(i + 1, t);
                    int varT1 = pair(i + 1, t + 1);
                    List<Integer> adds = addList.getOrDefault(varT1, new ArrayList<>());
                    List<Integer> dels = delList.getOrDefault(varT1, new ArrayList<>());

                    // persistence
                    List<Integer> c1 = new ArrayList<>();
                    c1.add(varT);
                    c1.addAll(adds);
                    c1.add(-varT1);
                    stateTransitionList.add(c1);

                    List<Integer> c2 = new ArrayList<>();
                    c2.add(-varT);
                    c2.addAll(dels);
                    c2.add(varT1);
                    stateTransitionList.add(c2);
                }
            }

            // add clauses
            this.currentDimacs.addAll(this.actionPreconditionList);
            this.currentDimacs.addAll(this.actionEffectList);
            this.currentDimacs.addAll(this.stateTransitionList);
            this.currentDimacs.addAll(this.actionDisjunctionList);

//            System.out.println("step " + t + " clauses:");
//            for (List<Integer> c : currentDimacs) {
//                System.out.println(c);
//            }
        }

        // update goal
        this.currentGoal.clear();
        this.currentGoal.addAll(this.goalList);

        System.out.println("Encoding : successfully done (" +
                (this.currentDimacs.size() + this.currentGoal.size()) +
                " clauses, " + to + " steps)");
    }
}
