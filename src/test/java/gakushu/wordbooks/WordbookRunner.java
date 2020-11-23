package gakushu.wordbooks;

import com.intuit.karate.junit5.Karate;

public class WordbookRunner {

    @Karate.Test
    Karate wordbookTest() {
        return Karate.run().relativeTo(getClass());
    }
}
