package flexlib.containers
{
   import flash.events.*;
   import flash.utils.describeType;
   import mx.containers.*;
   import mx.controls.*;
   import mx.core.Container;
   import mx.core.UIComponent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ValidationResultEvent;
   import mx.validators.Validator;
   
   [IconFile("AdvancedForm.png")]
   public class AdvancedForm extends Form
   {
      
      private var undoCounter:int = 0;
      
      [Bindable]
      private var _2073378034isValid:Boolean = true;
      
      private var _modelType:String = "shared";
      
      private var modelStack:Object;
      
      private var resetSnapshotKey:String = "reset";
      
      private var _undoHistorySize:int = 5;
      
      private var undoCurrentIndex:int = -1;
      
      private var validators:Object;
      
      private var noSnapshotFlag:Boolean = false;
      
      public function AdvancedForm()
      {
         super();
      }
      
      private function takeSnapshot() : void
      {
         if(!noSnapshotFlag)
         {
            if(undoCurrentIndex < undoCounter - 1)
            {
               undoCounter = undoCurrentIndex + 1;
            }
            snapshotValues(this.getChildren(),undoCounter + "");
            undoCurrentIndex = undoCounter;
            ++undoCounter;
         }
      }
      
      [Inspectable(category="General",enumeration="shared,memory",defaultValue="shared")]
      public function set modelType(value:String) : void
      {
         if(value == "shared")
         {
         }
      }
      
      private function doUndo() : void
      {
         var index:int = 0;
         noSnapshotFlag = true;
         index = undoCurrentIndex - 1;
         if(index >= undoCounter - 1 - undoHistorySize && index > -2)
         {
            --undoCurrentIndex;
            resetValues(this.getChildren(),getSnapshotKey(undoCurrentIndex));
         }
         noSnapshotFlag = false;
      }
      
      private function setValidatorListenerEvents(event:Event) : void
      {
         var container:Object = null;
         var classInfo:XML = null;
         var a:XML = null;
         var obj:Object = null;
         snapshotValues(this.getChildren(),resetSnapshotKey);
         container = document;
         if(!(container is Container))
         {
            return;
         }
         classInfo = describeType(container);
         validators = new Array();
         isValid = true;
         for each(a in classInfo..accessor)
         {
            try
            {
               if(container[a.@name] is Validator)
               {
                  isValid = false;
                  obj = new Object();
                  obj.reference = container[a.@name];
                  obj.isValid = false;
                  validators.push(obj);
                  Validator(container[a.@name]).addEventListener(ValidationResultEvent.VALID,setValidFlag,false,0,true);
                  Validator(container[a.@name]).addEventListener(ValidationResultEvent.INVALID,setValidFlag,false,0,true);
               }
            }
            catch(err:Error)
            {
               if(err.errorID != 1077)
               {
               }
            }
         }
      }
      
      private function snapshotValues(obj:Object, snapshotKey:String) : void
      {
         var snapshotModel:Object = null;
         var a:String = null;
         var tmpObj:Object = null;
         var tmpID:String = null;
         var value:Object = null;
         try
         {
            if(modelStack == null)
            {
               modelStack = new Object();
            }
            if(modelStack[snapshotKey] == null)
            {
               modelStack[snapshotKey] = new Object();
            }
            snapshotModel = modelStack[snapshotKey];
            for(a in obj)
            {
               if(obj[a] is FormItem)
               {
                  snapshotValues(obj[a].getChildren(),snapshotKey);
               }
               else
               {
                  tmpObj = obj[a];
                  tmpID = tmpObj.toString();
                  if(snapshotModel[tmpID] == undefined)
                  {
                     snapshotModel[tmpID] = new Object();
                  }
                  if(tmpObj is TextInput || tmpObj is TextArea)
                  {
                     value = tmpObj.text;
                  }
                  if(tmpObj is RadioButton || tmpObj is CheckBox)
                  {
                     value = tmpObj.selected;
                  }
                  if(tmpObj is ComboBox)
                  {
                     value = tmpObj.selectedIndex;
                  }
                  if(tmpObj is NumericStepper)
                  {
                     value = tmpObj.value;
                  }
                  if(tmpObj is TextInput || tmpObj is TextArea)
                  {
                     UIComponent(tmpObj).addEventListener(FocusEvent.FOCUS_OUT,textInputChange);
                  }
                  else
                  {
                     UIComponent(tmpObj).addEventListener(Event.CHANGE,controlChange);
                  }
                  snapshotModel[tmpID] = value;
               }
            }
         }
         catch(err:Error)
         {
         }
      }
      
      private function textInputChange(event:FocusEvent) : void
      {
         var snapshotModel:Object = null;
         var tmpKey:String = null;
         snapshotModel = getLastestSnapshot();
         tmpKey = event.target.parent.toString();
         if(snapshotModel[tmpKey] == undefined)
         {
         }
         if(snapshotModel[tmpKey] != event.target.parent.text)
         {
            takeSnapshot();
         }
      }
      
      private function getSnapshotKey(coutner:int) : String
      {
         if(coutner >= 0)
         {
            return coutner + "";
         }
         return resetSnapshotKey;
      }
      
      private function doRedo() : void
      {
         var index:int = 0;
         noSnapshotFlag = true;
         index = undoCurrentIndex + 1;
         if(index < undoCounter)
         {
            ++undoCurrentIndex;
            resetValues(this.getChildren(),getSnapshotKey(undoCurrentIndex));
         }
         noSnapshotFlag = false;
      }
      
      private function myKeyDownHandler(event:KeyboardEvent) : void
      {
         if(event.ctrlKey && event.keyCode == 90 && !(event.target is NumericStepper))
         {
            event.stopPropagation();
            event.preventDefault();
            doUndo();
         }
         else if(event.ctrlKey && event.keyCode == 89 && !(event.target is NumericStepper))
         {
            doRedo();
         }
         else
         {
            super.keyDownHandler(event);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isValid() : Boolean
      {
         return this._2073378034isValid;
      }
      
      public function set isValid(value:Boolean) : void
      {
         var oldValue:Object = null;
         oldValue = this._2073378034isValid;
         if(oldValue !== value)
         {
            this._2073378034isValid = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isValid",oldValue,value));
         }
      }
      
      public function get modelType() : String
      {
         return _modelType;
      }
      
      public function set undoHistorySize(value:int) : void
      {
         _undoHistorySize = value;
      }
      
      public function resetForm() : void
      {
         var children:Array = null;
         children = this.getChildren();
         resetValues(children,resetSnapshotKey);
         undoCounter = 0;
         undoCurrentIndex = -1;
         modelStack = new Object();
         snapshotValues(this.getChildren(),resetSnapshotKey);
      }
      
      private function getLastestSnapshot() : Object
      {
         if(undoCurrentIndex > -1)
         {
            return modelStack[undoCurrentIndex + ""];
         }
         return modelStack[resetSnapshotKey];
      }
      
      public function get undoHistorySize() : int
      {
         return _undoHistorySize;
      }
      
      private function setValidFlag(event:ValidationResultEvent) : void
      {
         var tmpFlag:Boolean = false;
         var i:int = 0;
         tmpFlag = true;
         for(i = 0; i < validators.length; i++)
         {
            if(validators[i].reference == event.target)
            {
               validators[i].isValid = event.type == ValidationResultEvent.VALID;
            }
            tmpFlag &&= Boolean(validators[i].isValid);
         }
         isValid = tmpFlag;
      }
      
      private function resetValues(obj:Object, snapshotKey:String) : void
      {
         var snapshotModel:Object = null;
         var a:String = null;
         var i:int = 0;
         var tmpObj:Object = null;
         var tmpID:String = null;
         var value:Object = null;
         if(modelStack[snapshotKey] == undefined)
         {
            throw new Error("Invalid snapshot");
         }
         try
         {
            for(i = 0; i < validators.length; i++)
            {
               isValid = false;
               Validator(validators[i].reference).enabled = false;
               validators[i].isValid = false;
            }
         }
         catch(err:Error)
         {
         }
         snapshotModel = modelStack[snapshotKey];
         for(a in obj)
         {
            if(obj[a] is FormItem)
            {
               resetValues(obj[a].getChildren(),snapshotKey);
            }
            else
            {
               tmpObj = obj[a];
               tmpID = tmpObj.toString();
               if(!(snapshotModel[tmpID] == undefined && (tmpObj is Container || !(tmpObj is TextInput) && !(tmpObj is RadioButton) && !(tmpObj is ComboBox) && !(tmpObj is NumericStepper))))
               {
                  if(snapshotModel[tmpID] == undefined)
                  {
                     throw new Error("Invalid obj in snapshot: " + tmpID);
                  }
                  if(tmpObj is TextInput || tmpObj is TextArea)
                  {
                     tmpObj.text = snapshotModel[tmpID];
                  }
                  if(tmpObj is RadioButton || tmpObj is CheckBox)
                  {
                     tmpObj.selected = snapshotModel[tmpID];
                  }
                  if(tmpObj is ComboBox)
                  {
                     tmpObj.selectedIndex = snapshotModel[tmpID];
                  }
                  if(tmpObj is NumericStepper)
                  {
                     tmpObj.value = snapshotModel[tmpID];
                  }
               }
            }
         }
         try
         {
            for(i = 0; i < validators.length; i++)
            {
               Validator(validators[i].reference).enabled = true;
            }
         }
         catch(err:Error)
         {
         }
      }
      
      private function strChildren(obj:Object) : String
      {
         var str:String = null;
         var a:String = null;
         str = "";
         for(a in obj)
         {
            str += a + "=[" + obj[a] + "]\n";
         }
         return str;
      }
      
      private function controlChange(event:Event) : void
      {
         if(event.target is RadioButton && !event.target.selected)
         {
            takeSnapshot();
         }
         if(!(event.target is RadioButton))
         {
            takeSnapshot();
         }
      }
      
      override protected function childrenCreated() : void
      {
         super.childrenCreated();
         parent.addEventListener("creationComplete",setValidatorListenerEvents);
         this.parent.addEventListener(KeyboardEvent.KEY_DOWN,myKeyDownHandler,false,0,true);
      }
   }
}

