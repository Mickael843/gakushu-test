package gakushu;

import com.intuit.karate.junit5.Karate;

class GakushuTest {
    
    @Karate.Test
    Karate testAll() {
        return Karate.run().relativeTo(getClass());
    }
    
}
