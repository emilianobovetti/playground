#define A0_PIN 14
#define BUTTONS_ANALOG_PIN A0_PIN

void setup(void)
{
    Serial.begin(9600);
}

void loop(void)
{
    unsigned int input = analogRead(BUTTONS_ANALOG_PIN);

    Serial.println(input);
}
