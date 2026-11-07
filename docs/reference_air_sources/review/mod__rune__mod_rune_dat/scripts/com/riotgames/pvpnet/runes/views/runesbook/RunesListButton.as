package com.riotgames.pvpnet.runes.views.runesbook
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.ds.IListX;
   import com.riotgames.platform.gameclient.domain.RuneType;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class RunesListButton extends ButtonX
   {
      
      private var _runeBin:RuneBin;
      
      private var titleTextField:TextFieldProxy;
      
      private var valueTextField:TextFieldProxy;
      
      private var _runes:IListX;
      
      private var headerText:StatefulView;
      
      public function RunesListButton(param1:IContext, param2:RuneBin)
      {
         this._runeBin = param2;
         super(param1);
         toggleOnClick = true;
         getSelectedChanged().add(this.selectedChangedHandler);
      }
      
      private function selectedChangedHandler() : void
      {
         if(getSelected())
         {
            this._runeBin.show();
         }
         else
         {
            this._runeBin.hide();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.headerText = new StatefulView(this);
         setTimelineChildByName("headerText",this.headerText);
         this.titleTextField = new TextFieldProxy(this);
         this.titleTextField.setText("");
         this.titleTextField.setAutoSize(TextFieldAutoSize.LEFT);
         this.headerText.setTimelineChildByName("titleTextField",this.titleTextField);
         this.valueTextField = new TextFieldProxy(this);
         this.valueTextField.setText("");
         setTimelineChildByName("valueTextField",this.valueTextField);
      }
      
      public function setListType(param1:int) : void
      {
         var _loc2_:String = "unknown";
         switch(param1)
         {
            case RuneType.RED_RUNE:
               _loc2_ = "marks";
               break;
            case RuneType.YELLOW_RUNE:
               _loc2_ = "seals";
               break;
            case RuneType.BLUE_RUNE:
               _loc2_ = "glyphs";
               break;
            case RuneType.BLACK_RUNE:
               _loc2_ = "quints";
         }
         this.headerText.setCurrentState(_loc2_);
      }
      
      public function setTitle(param1:String) : void
      {
         this.titleTextField.setText(param1);
         invalidateLayout();
      }
      
      protected function setValue(param1:uint) : void
      {
         this.valueTextField.setText("(" + param1 + ")");
         invalidateLayout();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this.titleTextField.setExplicitSize(NaN,NaN);
         this.valueTextField.setExplicitPosition(this.titleTextField.getX() + _loc3_.x + 5,NaN);
         return _asset.getBounds(null);
      }
      
      public function setRunes(param1:IListX) : void
      {
         if(this._runes != null)
         {
            this._runes.getReset().add(this.runesChangedHandler);
            this._runes.getItemsAdded().add(this.runesChangedHandler);
            this._runes.getItemsRemoved().add(this.runesChangedHandler);
         }
         this._runes = param1;
         if(this._runes != null)
         {
            this._runes.getReset().add(this.runesChangedHandler);
            this._runes.getItemsAdded().add(this.runesChangedHandler);
            this._runes.getItemsRemoved().add(this.runesChangedHandler);
            this.runesChangedHandler();
         }
      }
      
      private function runesChangedHandler() : void
      {
         this.setValue(this._runes.getLength());
         setEnabled(this._runes.getLength() > 0);
      }
   }
}

