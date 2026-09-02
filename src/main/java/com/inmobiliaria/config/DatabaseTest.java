package com.inmobiliaria.config;

import java.sql.Connection;

public class DatabaseTest {

    public static void main(String[] args) {

        try (Connection connection = ConnectionFactory.getConnection()) {

            System.out.println("=================================");
            System.out.println("CONEXIÓN EXITOSA");
            System.out.println("Base de datos conectada correctamente");
            System.out.println("=================================");

        } catch (Exception e) {

            System.out.println("=================================");
            System.out.println("ERROR DE CONEXIÓN");
            System.out.println("=================================");

            e.printStackTrace();
        }
    }
}
