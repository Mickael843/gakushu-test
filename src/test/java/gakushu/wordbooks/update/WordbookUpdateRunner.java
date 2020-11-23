package gakushu.wordbooks.update;

import com.intuit.karate.junit5.Karate;

public class WordbookUpdateRunner {

    @Karate.Test
    Karate testWordbookUpdate() {
        return Karate.run("wordbook-update").relativeTo(getClass());
    }
}
