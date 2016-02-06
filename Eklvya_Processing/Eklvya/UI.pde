void draw_UI()
{

  cp5 = new ControlP5(this);
  
    // create a DropdownList, 
  d1 = cp5.addDropdownList("Sport_Type")
          .setPosition(510, 50)
          .setSize(100,100)
          .setCaptionLabel("Sport Type")
          .setItemHeight(20)
          .setBarHeight(15)
          .addItem(" Boxing ", 1)
          .addItem(" Fencing ", 1);
          ;
          
  customize(d1); // customize the first list
  
  // create a second DropdownList
  d2 = cp5.addDropdownList("Sport_Regime")
          .setPosition(650, 50)
          .setSize(100,100)
          .setCaptionLabel("Sport Regime")
          .setItemHeight(20)
          .setBarHeight(15)
          .addItem(" Punches Per Minute ", 1)
          .addItem(" Punch Evaluation ", 1);
          ;
  
  customize(d2); // customize the second list
  
  font = loadFont("CourierNew36.vlw");
}

void customize(DropdownList ddl) {
  // a convenience function to customize a DropdownList
  ddl.setBackgroundColor(color(190));
  //ddl.scroll(0);
  ddl.setColorBackground(color(60));
  ddl.setColorActive(color(255, 128));
}

void keyPressed() {
 // some key events to change the properties of DropdownList d1
  if (key=='1') {
    // set the height of a pulldown menu, should always be a multiple of itemHeight
    d1.setHeight(210);
  } 
  else if (key=='2') {
    // set the height of a pulldown menu, should always be a multiple of itemHeight
    d1.setHeight(120);
  }
  else if (key=='3') {
    // set the height of a pulldown menu item, should always be a fraction of the pulldown menu
    d1.setItemHeight(30);
  } 
  else if (key=='4') {
    // set the height of a pulldown menu item, should always be a fraction of the pulldown menu
    d1.setItemHeight(12);
    d1.setBackgroundColor(color(255));
  } 
  else if (key=='5') {
    // add new items to the pulldown menu
    int n = (int)(random(100000));
    d1.addItem("item "+n, n);
  } 
  else if (key=='6') {
    // remove items from the pulldown menu  by name
    d1.removeItem("item "+cnt);
    cnt++;
  }
  else if (key=='7') {
    d1.clear();
  }
}

String trigger_list = "Select Game";

void controlEvent(ControlEvent theEvent) {
  // DropdownList is of type ControlGroup.
  // A controlEvent will be triggered from inside the ControlGroup class.
  // therefore you need to check the originator of the Event with
  // if (theEvent.isGroup())
  // to avoid an error message thrown by controlP5.

  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup   
  } 
  else if (theEvent.isController()) 
  {
    trigger_list = theEvent.getController().getName();
    boxing_trigger_type = theEvent.getController().getValue();
  }
}