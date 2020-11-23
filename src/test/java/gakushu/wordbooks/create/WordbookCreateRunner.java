package gakushu.wordbooks.create;

import com.intuit.karate.junit5.Karate;

public class WordbookCreateRunner {

    @Karate.Test
    Karate testWordbookCreate() {
        return Karate.run("wordbook-create").relativeTo(getClass());
    }
}
