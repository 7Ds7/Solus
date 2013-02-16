/*
 * Solus - Interactive Installation
 * v1.0 01-02-2012
 *
 * author: |Ds|
 * site: http://binaryunit.com/works/view/10
 * github:https://github.com/7Ds7/Solus
 *
 * 
 * Based on Jason Lessels and Bruce Allen scripts http://playground.arduino.cc/Main/MaxSonar
 *
 * This script get data from maxibot sensor, translate it to cm
 * and returns de median out of [9] reads
 */

const int pwPin = 7; //Set the pin to recieve the signal.
const int ledPin = 13; // For debugging purposes
int arraysize = 9; // Sample size, needs to be an odd number
int distance = 150; // Min distance to change state
char state = 'F'; // F is far C is close, to send to serial as byte format

int rangevalue[] = { 
  0, 0, 0, 0, 0, 0, 0, 0, 0}; // Holder for sensor values length = arraySize
long pulse; // Raw sensor value
long inches; // Sensor values in Inches
long cm; //Sensor value in cm
int modE; // To hold mode value from array


void setup() 
{
  Serial.begin( 9600 );
  delay( 500 ); //Wait for the serial connection
  Serial.print( state ); 
}

void loop() 
{
  pinMode( pwPin, INPUT );

  for( int i = 0; i < arraysize; i++ ) {								    
    pulse = pulseIn( pwPin, HIGH );
    inches = pulse/147; //147uS per inch
    cm = inches * 2.54; //change inches to centimetres
    rangevalue[i] = cm; //push the measurment to the array
    // Serial.println(cm);
    delay(10);
  }
  /*Serial.print("Unsorted: ");
   printArray(rangevalue,arraysize);*/
  isort( rangevalue, arraysize );
  /*Serial.print("Sorted: ");
   printArray(rangevalue,arraysize);*/
  modE = mode( rangevalue,arraysize );
  /*Serial.print("The mode/median is: ");
   Serial.println(modE);*/

  if ( modE <= distance && state!= 'C' ) {
    state = 'C';
    digitalWrite( ledPin, HIGH );
    Serial.print(state);  
  } 
  else if ( modE > distance && state != 'F' ) {
    state = 'F';
    digitalWrite(ledPin, LOW);
    Serial.print(state);
  }

  //Serial.println();
  //delay(1000);
}

/*-----------Functions------------*/
//Function to print the arrays.
void printArray( int *a, int n ) 
{
  for ( int i = 0; i < n; i++ )
  {
    Serial.print(a[i], DEC);
    Serial.print(' ');
  }
  Serial.println();
}

//Sorting function
//sort function (Author: Bill Gentles, Nov. 12, 2010)
void isort( int *a, int n ) 
{
  // *a is an array pointer function
  for ( int i = 1; i < n; ++i )
  {
    int j = a[i];
    int k;
    for ( k = i - 1; (k >= 0) && (j < a[k]); k-- )
    {
      a[k + 1] = a[k];
    }
    a[k + 1] = j;
  }
}

//Mode function, 
//returning the mode or median.
int mode( int *x,int n ) 
{
  int i = 0;
  int count = 0;
  int maxCount = 0;
  int mode = 0;
  int bimodal;
  int prevCount = 0;
  while( i < ( n-1 ) ){
    prevCount=count;
    count = 0;
    while( x[i] == x[i+1] ){
      count++;
      i++;
    }
    if( count>prevCount&count>maxCount ){
      mode = x[i];
      maxCount = count;
      bimodal = 0;
    }
    if( count == 0 ){
      i++;
    }
    if( count==maxCount ){//If the dataset has 2 or more modes.
      bimodal=1;
    }
    if( mode==0||bimodal==1 ){//Return the median if there is no mode.
      mode=x[(n/2)];
    }
    return mode;
  }
}
