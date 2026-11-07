package blix.components.button
{
   import blix.IDestructible;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class RadioButtonGroupX implements IDestructible
   {
      
      private var _selectedButton:ButtonX;
      
      private var _registeredButtons:Vector.<ButtonX> = new Vector.<ButtonX>();
      
      protected var _selectedButtonChanged:Signal = new Signal();
      
      public function RadioButtonGroupX()
      {
         super();
      }
      
      public function getSelectedButton() : ButtonX
      {
         return this._selectedButton;
      }
      
      public function setSelectedButton(param1:ButtonX) : void
      {
         if(param1 == this._selectedButton)
         {
            if(!this._selectedButton.getSelected())
            {
               this._selectedButton.setSelected(true);
            }
            return;
         }
         var _loc2_:int = this._registeredButtons.indexOf(param1);
         if(_loc2_ == -1 && param1 != null)
         {
            throw new ArgumentError("Button to be selected does not belong to the radio button group.");
         }
         var _loc3_:ButtonX = this._selectedButton;
         if(this._selectedButton != null)
         {
            this._selectedButton.setSelected(false);
         }
         this._selectedButton = param1;
         if(this._selectedButton != null)
         {
            this._selectedButton.setSelected(true);
         }
         this._selectedButtonChanged.dispatch(this,_loc3_,this._selectedButton);
      }
      
      public function addRadioButton(param1:ButtonX) : void
      {
         if(param1 == null)
         {
            return;
         }
         param1.addEventListener(MouseEvent.CLICK,this.clickHandler);
         this._registeredButtons.push(param1);
      }
      
      public function removeRadioButton(param1:ButtonX) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = this._registeredButtons.indexOf(param1);
         if(_loc2_ != -1)
         {
            if(this._selectedButton == param1)
            {
               this.setSelectedButton(null);
            }
            param1.removeEventListener(MouseEvent.CLICK,this.clickHandler);
            this._registeredButtons.splice(_loc2_,1);
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:ButtonX = null;
         for each(_loc1_ in this._registeredButtons)
         {
            this.removeRadioButton(_loc1_);
         }
         this._selectedButtonChanged.removeAll();
         this._registeredButtons = null;
      }
      
      private function clickHandler(param1:Event) : void
      {
         this.setSelectedButton(ButtonX(param1.currentTarget));
      }
      
      public function getSelectedButtonChanged() : ISignal
      {
         return this._selectedButtonChanged;
      }
   }
}

