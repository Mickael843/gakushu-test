package gakushu;


import com.github.javafaker.Faker;

import java.time.LocalDateTime;
import java.util.Locale;
import java.util.UUID;

public class DataGenerator {

    private static final String defaultLocale = "en-US";

    public static String uuid() {
        return UUID.randomUUID().toString();
    }

    public static int randomMonth() {
        return faker().number().numberBetween(1, 12);
    }

    public static String randomName() {
        return faker().pokemon().name();
    }

    public static String dateTime() {
        return LocalDateTime.now().toString();
    }

    public static Faker faker() {
        return DataGenerator.faker(DataGenerator.defaultLocale);
    }

    public static Faker faker(String locale) {
        return new Faker(new Locale(locale));
    }
}
