package com.inmobiliaria.config;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class ConnectionFactory {

    private static final Properties properties = new Properties();

    static {
        try (InputStream input = ConnectionFactory.class
                .getClassLoader()
                .getResourceAsStream("db.properties")) {

            if (input == null) {
                throw new RuntimeException(
                        "No se encontró el archivo db.properties"
                );
            }

            properties.load(input);

            Class.forName(
                    properties.getProperty("db.driver")
            );

        } catch (IOException | ClassNotFoundException e) {
            throw new RuntimeException(
                    "Error cargando la configuración de la base de datos",
                    e
            );
        }
    }

    public static Connection getConnection() throws SQLException {

        return DriverManager.getConnection(
                properties.getProperty("db.url"),
                properties.getProperty("db.username"),
                properties.getProperty("db.password")
        );
    }
}
