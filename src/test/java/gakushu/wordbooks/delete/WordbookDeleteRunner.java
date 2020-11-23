package gakushu.wordbooks.delete;

import com.intuit.karate.junit5.Karate;

public class WordbookDeleteRunner {

    @Karate.Test
    Karate testWordbookDelete() {
        return Karate.run("wordbook-delete").relativeTo(getClass());
    }
}
