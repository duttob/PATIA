package sokoban;

import com.codingame.gameengine.runner.SoloGameRunner;

public class SokobanMain {
    public static void main(String[] args) {
        SoloGameRunner gameRunner = new SoloGameRunner();
        gameRunner.setAgent("python3 agent.py " + args[0]);
        gameRunner.setTestCase(args[1]);

        gameRunner.start();
    }
}
