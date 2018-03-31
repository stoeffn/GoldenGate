//#-end-hidden-code
/*:

 # Multiplexer
 The circuit in the live view contains both a multiplexer as well as a inverese multiplexer. Basically, they allow selecting which signal to transmit.

 The button on the top "selects" one of the other to buttons and transmits its state through one wire. It also "selects" the corresponding LED on the right. To put it in other words, one wire can now be reused for different use-cases.

 In this basic example, this pattern doesn't really yield an advantage since you need another cable for transmitting which LED to use. However, if you had two eight-bit integers you can now send and receive them with nine instead of 16 wires.

 If you now had flip-flops at the right side the LEDs wouldn't even lose their values.

 * Note:
 When switching, the LED flickers a little bit because of the not gates [propagation delay](glossary://PropagationDelay).

 */
//#-code-completion(everything, hide)
//#-editable-code Nothing to Code Here
//#-end-editable-code
