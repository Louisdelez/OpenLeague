package com.riotgames.pvpnet.runes.views.common
{
   import blix.components.button.LabelButtonX;
   import blix.components.renderer.IItemRenderer;
   import blix.components.renderer.ISelectableRenderer;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import flash.events.MouseEvent;
   
   public class RunePageListRenderer extends LabelButtonX implements IItemRenderer, ISelectableRenderer
   {
      
      private var _index:uint;
      
      private var _selectionRequested:Signal = new Signal();
      
      private var _bookPage:SpellBookPageDTO;
      
      public function RunePageListRenderer(param1:IContext)
      {
         super(param1);
         setLinkage("runes.iron.RunePageListRenderer");
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         unassignToolTip(this);
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         assignToolTip(this,this._bookPage.displayName);
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         this._selectionRequested.dispatch(this,param1.ctrlKey,param1.shiftKey);
      }
      
      override public function setData(param1:*) : void
      {
         super.setData(param1);
         this.setSpellPageDTO(param1 as SpellBookPageDTO);
      }
      
      private function setSpellPageDTO(param1:SpellBookPageDTO) : void
      {
         if(param1 != null && param1 != this._bookPage)
         {
            setText(param1.displayName);
            this._bookPage = param1;
         }
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      public function getSelectionRequested() : ISignal
      {
         return this._selectionRequested;
      }
   }
}

