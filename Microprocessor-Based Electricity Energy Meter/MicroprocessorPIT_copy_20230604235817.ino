#include <WiFi.h>
#include <WiFiAP.h>
#include <WiFiClient.h>
#include <WiFiGeneric.h>
#include <WiFiMulti.h>
#include <WiFiSTA.h>
#include <WiFiScan.h>
#include <WiFiServer.h>
#include <WiFiType.h>
#include <WiFiUdp.h>
#include <LiquidCrystal_I2C.h>
#include "EmonLib.h"
#include <EEPROM.h>
#include <FirebaseESP32.h>
#include <addons/TokenHelper.h>
#include <addons/RTDBHelper.h>
#define vCalibration 115.07
#define currCalibration 1.40
#define WIFI_SSID "troix"
#define WIFI_PASSWORD "12345678"
#define DATABASE_URL "https://electricity-energy-meter-56b20-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "o92XclBYFI4WXPC94BfKMcVBMGEVriQglCCSH2VC"
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
LiquidCrystal_I2C lcd(0x27, 16, 2);
EnergyMonitor emon;
const int relayPin = 33;
float kWh = 0;
float power = 0;
unsigned long lastmillis = millis();
unsigned long duration = 0;


// void IRAM_ATTR interruptRising() {
//   digitalWrite(relayPin, HIGH);
//   delay(1000);
// }

// void IRAM_ATTR interruptFalling() {
//   delay(10000);
//   digitalWrite(relayPin, LOW);
// }

void setup() {
  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  lcd.init();
  lcd.backlight();
  emon.voltage(35, vCalibration, 1.7);
  emon.current(34, currCalibration);
  lcd.setCursor(0, 0);
  lcd.print("Power Puff Girls");
  lcd.setCursor(4, 1);
  lcd.print("Micro PIT");
  delay(3000);
  lcd.clear();
  pinMode(16, OUTPUT);
  // Firebase.begin("https://electricity-energy-meter-56b20-default-rtdb.firebaseio.com/", "o92XclBYFI4WXPC94BfKMcVBMGEVriQglCCSH2VC");
  // config.api_key = API_KEY;
  // auth.user.email = USER_EMAIL;
  // auth.user.password = USER_PASSWORD;
  // config.database_url = DATABASE_URL;
  // config.token_status_callback = tokenStatusCallback;
  // Firebase.begin(&config, &auth);
  config.database_url = DATABASE_URL;
  config.signer.test_mode = true;
  config.token_status_callback = tokenStatusCallback;
  Firebase.reconnectWiFi(true);
  Firebase.begin(DATABASE_URL, FIREBASE_AUTH);
  duration = millis();
}

void loop() {
  emon.calcVI(20, 2000);
  if (emon.Irms <0.09){
    power = emon.Vrms * 0;
  }else{
    power = emon.Vrms * emon.Irms;
  }
  kWh = kWh + power*(millis()-lastmillis)/3600000000.0;
  // attachInterrupt(digitalPinToInterrupt(relayPin), interruptRising, RISING); //power outtage
  // attachInterrupt(digitalPinToInterrupt(relayPin), interruptFalling, FALLING); //initialization
  delay(1000);
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print(String("VRMS: ") + String(emon.Vrms) + String("V"));
  lcd.setCursor(0, 1);
  lcd.print(String("IRMS: ") + String(emon.Irms) + String("A"));
  delay(1000);
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print(String("Power: ") + String(power) + String("W"));
  lcd.setCursor(0, 1);
  lcd.print(String("KWH: ") + String(kWh) + String("W"));
  delay(100);

  Serial.print("Vrms: ");
  Serial.print(emon.Vrms, 2);
  Serial.print("V");
  Serial.print("\tIrms: ");
  Serial.print(emon.Irms, 4);
  Serial.print("A");
  Serial.print("\tPower: ");
  Serial.print(emon.apparentPower, 4);
  Serial.print("W");
  Serial.print("\tkWh: ");
  Serial.print(kWh, 5);
  Serial.println("kWh");
  writeToFirebase();
}

void writeToFirebase() {
  if (Firebase.ready())
  {
    Serial.printf("Setting VRMS... %s\n", Firebase.setFloat(fbdo, F("ESP32/VRMS"), emon.Vrms) ? "done!" : fbdo.errorReason().c_str());
    Serial.printf("Setting IRMS... %s\n", Firebase.setFloat(fbdo, F("ESP32/IRMS"), emon.Irms) ? "done!" : fbdo.errorReason().c_str());
    Serial.printf("Setting Power... %s\n", Firebase.setFloat(fbdo, F("ESP32/Power"), emon.apparentPower) ? "done!" : fbdo.errorReason().c_str());
    Serial.printf("Setting KWH... %s\n", Firebase.setFloat(fbdo, F("ESP32/KWH"), kWh) ? "done!" : fbdo.errorReason().c_str());
 // Serial.printf("Get float... %s\n", Firebase.getFloat(fbdo, F("/test/float")) ? String(fbdo.to<float>()).c_str() : fbdo.errorReason().c_str());
} else {
  Serial.printf("Firebase not Ready!");
}
  //     if (Firebase.RTDB.setFloat(&fbdo, "test/float", 0.01 + random(0,100))){
  //     Serial.println("PASSED");
  //     Serial.println("PATH: " + fbdo.dataPath());
  //     Serial.println("TYPE: " + fbdo.dataType());
  //   }
  //   else {
  //     Serial.println("FAILED");
  //     Serial.println("REASON: " + fbdo.errorReason());
  //   }
  // Firebase.RTDB.setFloat(&fbdo, "ESP32/VRMS/", emon.Vrms);
  // Firebase.setFloat(IRMSfirebaseData, "ESP32/IRMS", emon.Irms);
  // Firebase.setFloat(PowerfirebaseData, "ESP32/Power", emon.apparentPower);
  // Firebase.setFloat(KWHfirebaseData, "ESP32/KWH", kWh);

  // IRMSfirebaseData.stringData()
  // PowerfirebaseData.stringData()
  // KWHfirebaseData.stringData()
}
  // double Current = getCurr();
  // double IRMS = (Current / 2.0) * 0.707;
  // double Voltage = getVPP();
  // double VRMS = (Voltage / 2.0) * 0.707;
  // lcd.setCursor(0, 0);
  // lcd.print(String("IRMS: ") + String(IRMS));
  // lcd.setCursor(0, 1);
  // lcd.print(String("VRMS: ") + String(VRMS));
// }

// float getCurr() {
//   float result;
//   int readValue;
//   int maxValue = 0;
//   int minValue = 4096;

//   uint32_t start_time = millis();
//   while ((millis() - start_time) < 1000) {
//     readValue = analogRead(34);
//     if (readValue > maxValue) {
//       maxValue = readValue;
//     }
//     if (readValue < minValue) {
//       minValue = readValue;
//     }
//   }

//   result = ((maxValue - minValue) * 3.3) / 4096.0;

//   return result;
// }

// float getVPP() {
//   float result;
//   int readValue;
//   int maxValue = 0;
//   int minValue = 4096;

//   uint32_t start_time = millis();
//   while ((millis() - start_time) < 1000) {
//     readValue = analogRead(35);
//     if (readValue > maxValue) {
//       maxValue = readValue;
//     }
//     if (readValue < minValue) {
//       minValue = readValue;
//     }
//   }

//   result = ((maxValue - minValue) * 3.3) / 4096.0;

//   return result;
// }