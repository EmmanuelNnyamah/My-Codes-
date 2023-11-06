import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class SecretOfTheIsland {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        List<Map> maps = new ArrayList<>();
        String mapName = null;

        // Constructor to initialize maps from folio.txt
        try (BufferedReader reader = new BufferedReader(new FileReader("folio.txt"))) {
            int numMaps = Integer.parseInt(reader.readLine());
            for (int i = 0; i < numMaps; i++) {
                String line = reader.readLine();
                String[] parts = line.split(",");
                if (parts.length == 3) {
                    Map map = new Map(parts[0], Integer.parseInt(parts[1]), parts[2]);
                    maps.add(map);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading folio.txt");
            e.printStackTrace();
        }

        int option = -1;

        System.out.print("Welcome to the Secret of the Island! Choose an option to start the game." + "\n"
                + "1-See all maps\r\n" + //
                "2-Open map\r\n" + //
                "3-Decrypt map\r\n" + //
                "4-Write down secret\r\n" + //
                "5-Send information to Captain Lila\r\n" + //
                "0-Exit\r\n");

        // while loop to control user input
        while (option != 0) {
            System.out.print("Option: ");

            if (scanner.hasNextInt()) {
                option = scanner.nextInt();
                System.out.println();

                if (option == 1) {
                    for (Map map : maps) {
                        System.out.println(map.toString());
                    }
                    System.out.println();
                } else if (option == 2) {
                    System.out.print("Which map do you want to open?" + "\n" + "Map Name: ");
                    mapName = scanner.next(); // Store the selected map name
                    System.out.println();

                    for (Map map : maps) {
                        if (mapName.equalsIgnoreCase(map.mapName)) { // Compare map name directly
                            try {
                                File f = new File(map.fileName);
                                Scanner sc = new Scanner(f);
                                while (sc.hasNextLine()) {
                                    System.out.println(sc.nextLine());
                                }
                                System.out.println();
                            } catch (IOException e) {
                                System.err.println("Error reading map file: " + map.fileName);
                                e.printStackTrace();
                            }
                            break;
                        }
                    }
                    if (mapName == null) {
                        System.out.println("Map not found.");
                        System.out.println();
                    }
                } else if (option == 3) {
                    if (mapName == null) {
                        System.out.println("No map selected. Please open a map first.");
                    } else {
                        for (Map map : maps) {
                            if (mapName.equalsIgnoreCase(map.mapName)) {
                                try {
                                    File f = new File(map.fileName);
                                    Scanner sc = new Scanner(f);

                                    while (sc.hasNextLine()) {
                                        String line = sc.nextLine().trim();
                                        String[] spaceSeparatedValues = line.split("\\s+");
                                        for (String spaceSeparatedValue : spaceSeparatedValues) {
                                            String[] asciiValues = spaceSeparatedValue.split(",");
                                            for (String value : asciiValues) {
                                                if (!value.isEmpty()) {
                                                    int ascii = Integer.parseInt(value.trim());
                                                    char character = (char) ascii;
                                                    System.out.print(character);
                                                }
                                            }
                                            System.out.print(" ");
                                        }
                                    }
                                    System.out.println();
                                    System.out.println("Map " + mapName + " has been decrypted!");
                                    System.out.println();
                                    map.isEncrypted = false;
                                    break;
                                } catch (IOException e) {
                                    System.err.println("Error reading map file: " + map.fileName);
                                    e.printStackTrace();
                                }
                            }
                        }
                    }
                } else if (option == 4) {
                    if (mapName == null) {
                        System.out.println("No map selected. Please open a map first.");
                    } else {
                        System.out.println("What is the " + mapName + " secret?");
                        String secret = scanner.next();
                        for (Map map : maps) {
                            if (mapName.equalsIgnoreCase(map.mapName)) {
                                map.secret = secret;
                                System.out.println(map.toString());
                                System.out.println();
                                break;
                            }
                        }
                    }
                } else if (option == 5) {
                    List<String> secrets = new ArrayList<>();
                    for (Map map : maps) {
                        if (map.secret != null && !map.secret.isEmpty()) {
                            secrets.add(map.secret);
                            System.out.println("Successfully wrote secret to the file" + "\n" + map.secret + "\n");
                        }
                    }

                    if (secrets.isEmpty()) {
                        System.out.println("No secrets to send to Captain Lila.");
                    } else {
                        try {
                            String filename = "secrets.txt";
                            try (PrintWriter writer = new PrintWriter(filename)) {
                                for (String secret : secrets) {
                                    writer.println(secret);
                                }
                            }

                        } catch (IOException e) {
                            System.err.println("Error writing secrets to the file.");
                            e.printStackTrace();
                        }
                    }
                } else if (option == 0) {
                    // Delete the secrets.txt file if it exists
                    File secretsFile = new File("secrets.txt");
                    if (secretsFile.exists()) {
                        if (secretsFile.delete()) {
                            System.out.println("File: secrets.txt is deleted!" + "\n");
                        } else {
                            System.out.println("Failed to delete the secrets file.");
                        }
                    }
                    System.out.println("Game over." + "\n" + "\n" + "End of program.");
                } else {
                    System.out.println("PLEASE CHOOSE A VALID OPTION");
                }
            } else {
                System.out.println();
                System.out.println("PLEASE CHOOSE A VALID OPTION");
                scanner.nextLine(); // Clear the invalid input
            }
        }
    }
}

class Map {
    public String mapName;
    public int year;
    public String fileName;
    public boolean isEncrypted;
    public String secret;

    // Constructor to initialize Map variables
    public Map(String mapName, int year, String filename) {
        this.mapName = mapName;
        this.year = year;
        this.fileName = filename;
        this.isEncrypted = true;
        this.secret = null;
    }

    // Map toString to write the state of the maps
    public String toString() {
        return "Map: " + mapName + " Year: " + year + " Is Encrypted? " + isEncrypted + " Secret: " + secret;
    }
}
