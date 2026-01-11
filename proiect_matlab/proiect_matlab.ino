//declararea pinilor ledului si al butonului
const int ledPin = 15;
const int buttonPin = 4;

//declararea datelor ajutatoare
bool sistemActiv = false; //retine daca butonul este on sau off practic
bool stareLed = false;   // defineste starea ledului(on sau off)
unsigned long ultimulTimpBlink = 0; //pt cronometrare
const long interval = 1000;//interval de 1s

void setup() {
  Serial.begin(115200);//upload speed 115200
  //setarea pinilor, OUT pt led deoarece primeste comanda de la placa, IN pt buton deorece da el comanda catre placa
  pinMode(ledPin, OUTPUT);
  pinMode(buttonPin, INPUT_PULLUP);
}

void loop() {
  //daca butonul nu este apasat sistemul este activ adica ledul trb sa clipeasca
  if (digitalRead(buttonPin) == LOW) {
    sistemActiv = !sistemActiv;
    delay(300); //asta e ca sa nu citeasca de mai multe ori, adica sa nu consideere codul ca butonul  s-a apast de mai multe ori la o singura apasare
  }
//daca sistemul este activ
  if (sistemActiv==true) {
    unsigned long timpCurent = millis();//verificam cat timp a trecut folosind millis()
    
    if (timpCurent - ultimulTimpBlink >= interval) //daca a trecut 1s de la ultima schimbare
     {
      ultimulTimpBlink = timpCurent;//salvam momementul ultimei schimbari
      stareLed = !stareLed;//se porneste ledul
      digitalWrite(ledPin, HIGH);
    }
  } else {
    stareLed = false;
    digitalWrite(ledPin, LOW);//se stinge ledul
  }

  if (stareLed) {
    Serial.println(1);//daca se aprinde se afiseaza 1 in seriala
  } else {
    Serial.println(0);//daca se se stinge se afiseaza 0 in seriala
  }

  delay(50); //sa nu se trimita asa de multe puncte catre matlab
}