---
layout: post
title: Flex - getElementByID
slug: flex-getelementbyid
date: 2008-12-22
categories:
- Development
- Flex Apps
- MGB
tags:
- Actionscript
- AIR
- FLEX
status: publish
type: post
published: true
---
<p>Currently working on and revising an AIR application written in Flex, I needed to be able to control the instance of an object within Actionscript by referencing it's ID.</p>
<p>Here's the scenario.</p>
<p>I have created a list within FLEX containing parent and child checkboxes. I wanted to be able to control the toggle display (true or false) of the child checkboxes based upon the click action of the parent - if I de-selected the parent, all children should also be set to false and vice versa.</p>
<p>Here is the snippet of code used to create the list:</p>
<pre>
public function createCheckBoxDisplay():void {
var masterCount:int;
for(masterCount=0;masterCount&lt;masterSlideArray.length;masterCount++) {
var chapterNumber:int = masterCount+1;
var chapterTitle:String = masterSlideArray[masterCount][0].toString();

// get the items and create the output for the chapter slide selection edit
var slideCLVert:VBox = new VBox();
slideCLVert.name = 'vertBox' + masterCount;
var chapterTitleCheckBox:CheckBox = new CheckBox();
chapterTitleCheckBox.id = masterCount.toString();
chapterTitleCheckBox.addEventListener(MouseEvent.CLICK, chapterCheckBoxValue);

// check to see if we can pre-populate the master checkbox based on the slide selections
var slideInt:int;
var slideCheckNumber:int = 0;
for(slideInt=0;slideInt&lt;masterSlideArray[masterCount][1].length;slideInt++) {
if(masterSlideArray[masterCount][1][slideInt].showSlide == 'true') {
slideCheckNumber = slideCheckNumber+1;
}
}
// if the number of 'child' check boxes selected equals the total number of children
// select the main chapter checkbox
if (masterSlideArray[masterCount][1].length == slideCheckNumber) {
chapterTitleCheckBox.selected = true;
}

var chapterTitleLabel:Label = new Label();
var titleHBox:HBox = new HBox();
titleHBox.name = 'TitleHBox' + masterCount;

chapterTitleLabel.text = 'Chapter ' + chapterNumber + ': ' + chapterTitle;

titleHBox.addChild(chapterTitleCheckBox);
titleHBox.addChild(chapterTitleLabel);

// add the titleHBox to the VBox
slideCLVert.addChild(titleHBox);

// get the children from the array
for(slideInt=0;slideInt&lt;masterSlideArray[masterCount][1].length;slideInt++) {
var slideNumber:int = slideInt+1;
var slideHBox:HBox = new HBox();
slideHBox.name = 'slideHBox' + masterCount + '_' + slideInt;

var clCheckBox:CheckBox = new CheckBox();
clCheckBox.id = masterCount + '_' + slideInt;
clCheckBox.name = 'slideCheckBox' + masterCount + '_' + slideInt;
clCheckBox.addEventListener(MouseEvent.CLICK, changeCheckBoxValue);

if(masterSlideArray[masterCount][1][slideInt].showSlide == 'true') {
clCheckBox.selected = true;
}

var clSlideName:Label = new Label();
clSlideName.text = 'Slide ' + slideNumber;

var slideSpacer:Spacer = new Spacer();
slideSpacer.width = 20;

slideHBox.addChild(slideSpacer);
slideHBox.addChild(clCheckBox);
slideHBox.addChild(clSlideName);
slideCLVert.addChild(slideHBox);
}
selectionBox.addChild(slideCLVert);
}

var commitButton:Button = new Button();
commitButton.label = 'Save Changes';
commitButton.addEventListener(MouseEvent.CLICK, saveChanges);
var buttonHBox:HBox = new HBox();
buttonHBox.addChild(commitButton);
selectionBox.addChild(buttonHBox);

}</pre>
<p>It loops through two arrays (master and child) and creates the form fields required to display all options, formatting the display output using HBox and VBox components.</p>
<p>The onclick event for the master checkboxes was sending the correct details through that I needed to create the ID's for the children to change their value. As I continued my search, I found out that AS and FLEX do not have a function such as getElementByID. Damn them. This would have been perfect.</p>
<p>So, the only option was to write a new one.</p>
<p>The onClick event was calling the following function, that was sending through the master ID as one of the parameters, and was using the returned value to create an instance of the checkbox to change the value.</p>
<p>var thisCheckBox:CheckBox = getChildById(selectionBox,chapterID,slideInt);</p>
<p>Here's the getChildById function:</p>
<p>private function getChildById(g:Box, parentID:int, childID:int):CheckBox {<br />
for each (var gr:VBox in g.getChildren()) {<br />
     for each (var gi:HBox in gr.getChildren()) {<br />
          if(gi.name == 'slideHBox' + parentID + '_' + childID ) {<br />
               var thisRootTarget:DisplayObjectContainer = gi;<br />
               var giCount:int; for(giCount=0;giCount&lt;thisRootTarget.numChildren;giCount++) {<br />
                    if (gi.getChildAt(giCount) is CheckBox) {<br />
                         return CheckBox(gi.getChildAt(giCount));<br />
                    }<br />
               }<br />
           }<br />
     }<br />
 }<br />
return null;<br />
}</p>
<p>It's a relatively simple function. This is tailored to suit my needs for this purpose as it references the tupes of display components I used to build to display, but you can edit and amend it to work for you quite easily.</p>
<p>Looping through the children in the main container, it continues looping through until it finds the child checkboxes within the correct parent HBox (slideHBox). Once found, this object is transformed to a rootTarget variable, and the number of children is then counted. The names of the children are then returned to the calling function, and the value of the boxes are set as required.</p>
<p>It may look a bit complex (or not) and I know that my description of what's going on here needs some major work (apologies for that), but I wanted to place it here for two reasons: 1) my own reference, and 2) you never know, <em>someone</em> <em>somewhere</em> might find this useful.</p>
