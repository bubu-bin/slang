/**
 * This program converts a temperature from Celsius to Fahrenheit.
 */

homie factor = 18;  // Scaled factor to avoid floating-point (1.8 scaled by 10)
homie offset = 32;
homie celsius = 24;

// Perform the conversion
homie fahrenheit = (celsius * factor) / 10 + offset; 

shout("Temperature in Fahrenheit: ");
shout(fahrenheit);