/* Super Trivial Teensy Password Key */
/* Derived from the Public Domain "Simple USB Keyboard Example" in the TeensyDuino Examples */

/* These instructions assume you're using the Arduino IDE with TeensyDuino Extensions configured to allow compiling HEX Files for Teensy++ 2.0 */
/* You must select "Teensy++ 2.0" from the "Tools > Board" menu (Obviously. You're using a Teensy and not an Arduino Uno) */
/* You must also select "Keyboard + Mouse" from the "Tools > USB Type" menu in the Arduino IDE. */

#define HW_PASS "snarfblatt123" // Sorry for the hard-coding, folks -- this IS a "Super Trivial" example, after all.
#define DELAY_SECONDS 30
#define LED_PIN 6  // Teensy++ 2.0 has the LED wired on Pin 6. Adjust for your own hardware if needed. (Pin 11, Pin 13)
#define PW_DEBUG true

/* send_keys transmits a string message over USB HID (Keyboard). It should also send it over the Serial Port if you set the PW_DEBUG flag to true. */
/* Meh, who knows -- Serial Port transmission might be useful for Embedded Linux devices that only have a Serial Port console. */
void send_keys(char* message) {
  Keyboard.println(message);
  if (PW_DEBUG)
    Serial.println(message); // Also send to the Arduino Serial Monitor if you're debugging
}

/* Bulk of the LED Blinking code. Assumes LED is in OFF State. delay_ms_(on/off) is the time in milliseconds to keep the LED in a specific state. */
void blink_led(int delay_ms_on, int delay_ms_off) {
  digitalWrite(LED_PIN, HIGH);   // set the LED on
  delay(delay_ms_on);
  
  digitalWrite(LED_PIN, LOW);    // set the LED off
  delay(delay_ms_off);
}


/* Since the Password transmission is a one-time thing, it makes sense to drop it into the setup() section, rather than the loop() section. */
void setup() {
  if (PW_DEBUG)
    Serial.begin(9600); // Strictly for the Serial-Port Debugging Diagnostics.

  pinMode(LED_PIN, OUTPUT);      // We'll blink on Pin 6 to give a visual indication that the password was transmitted.
  
  // All this is just Blinking Lights eye candy for the Countdown Timer.
  // LED will remain ON when the Teensy starts up.
  // At 10 seconds, the LED will start blinking slowly.
  // At 5 seconds, the LED will start blinking faster until the countdown is reached.
  for (int i=DELAY_SECONDS;i>0;i--)
    if (i > 10) {
      blink_led(1000,0);
    } else if (i > 5) {
      blink_led(500,500);
    } else {
      blink_led(250,250);
      blink_led(250,250);
    }

  // When the countdown is reached, type in the Password.
  send_keys(HW_PASS);
  
  // Finally, keep the LED in OFF state for a couple of seconds (versus the fast blinking state) to give a visual indication that the Password has been transmitted.
  blink_led(0,2000);
}

void loop() {
  // Finally, since the code wants to run in an infinite loop, we simply do a slow-blink.
  blink_led(250,5000);
}
