/**
 * Illegal operations.
 */

// Type mismatch errors: Operations between a string and a number
shout("string" + 2); // Attempt to add a string and a number
shout("string" - 2); // Attempt to subtract a number from a string
shout("string" / 2); // Attempt to divide a string by a number
shout("string" * 2); // Attempt to multiply a string by a number

// Type mismatch with variables
homie string = "string";
homie number = 2;
shout(string + number); // Attempt to add a string variable to a number variable

// Division by zero error
shout(5 / 0); // Attempt to divide by zero

// Assigning to an undefined variable
homie variable = notDefined; // Attempt to assign a value from an undefined variable