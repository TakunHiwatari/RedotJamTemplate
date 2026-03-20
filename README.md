# Redot Game Jam Template
A simple template for Redot Game Jams that contains a Main Menu, Options Menu, Credits Menu, Pause Menu, and Controls Menu. 

![image](https://github.com/user-attachments/assets/9e34f6e0-cdf3-41d4-bf93-3afafedd61b3)



# How to install
1) Download the template
2) Copy the redot_jam_template and default_bus_layout.tres to the root folder of your project

NOTE: Some filepaths are hardcoded so leave everything where they are.


# How to use


## Main Menu
1) Change the text of GameNameLabel to the title of your game
2) Click on the MainMenu node, go to the Game Scene part of the inspector, and add the PackedScene for your game.

![image](https://github.com/user-attachments/assets/64225800-6142-474e-bc25-0bff193bf71e)


## Options Menu
The Options Menu is already configured. The volume sliders adjust the settings from default_bus_layout.tres. Just run your Music through the Music bus and your SFX through the Sfx bus.


## Controls Menu
1) Click on the ControlsMenu node, go to the Inputs part of the inspector, and add an element to the array for each input your game has.
2) Make sure that what you type matches EXACTLY with what you have in your project's Input Map settings. This is case-sensitive.
3) Add themes to the Label Theme and Button Theme in the inspector (optional)
4) Run the ControlsMenu scene in the editor to make sure you set it up correctly. It should generate the list of inputs from the array and list the corresponding Input Mappings from your project settings.

![image](https://github.com/user-attachments/assets/41f213b8-5f52-4663-a499-4957bbe901f6)
![image](https://github.com/user-attachments/assets/845e4eff-ce5f-4853-bf8b-da161909de70)
![image](https://github.com/user-attachments/assets/c631e4f1-435f-4e04-8345-edecb7e6fc93)


## Credits Menu
For the Credits Menu you will have to add a Label for the title/ role, and another label for the person being credited. There's already some labels and LinkButtons set up in the template so you can visually see what it looks like. If you do decide to use LinkButtons, make sure you provide the approprite link to the person's work in the URI field.

![image](https://github.com/user-attachments/assets/54a1fbe8-f580-4ff5-81ff-9ddc3f89f33f)
![image](https://github.com/user-attachments/assets/f45340b3-05a2-4b3b-9dcf-aa8132603ed9)


## Pause Menu
The Pause Menu is already configured. Create a pause button in input mappings, and create the code in your game to instantiate and add the scene to your game when the pause button is pressed.

![image](https://github.com/user-attachments/assets/6b6d2d2f-ac84-477a-b804-fb973b6ca4fd)

![image](https://github.com/user-attachments/assets/187071b5-9605-416c-942f-7dc6b2d97168)
