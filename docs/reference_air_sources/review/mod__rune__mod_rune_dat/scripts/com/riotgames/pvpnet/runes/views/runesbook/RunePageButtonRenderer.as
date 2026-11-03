package com.riotgames.pvpnet.runes.views.runesbook
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.renderer.ISelectableRenderer;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesViewController;
   import flash.events.MouseEvent;
   
   public class RunePageButtonRenderer extends LabelButtonX implements ISelectableRenderer
   {
      
      private var sizer:SpriteProxy;
      
      private var _model:SpellBookPageDTO;
      
      private var _selectionRequested:Signal = new Signal();
      
      private var runesViewController:RunesViewController;
      
      private var soundProvider:ISoundProvider;
      
      private var _index:uint;
      
      public function RunePageButtonRenderer(param1:IContext)
      {
         super(param1);
         setLinkage("RunePageButtonRenderer");
         setMouseChildren(true);
         addEventListener(MouseEvent.CLICK,this.mouseClickHandler);
         addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.runesViewController = getDependency(RunesViewController);
         this.soundProvider = getDependency(ISoundProvider);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.sizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this.sizer);
      }
      
      private function mouseClickHandler(param1:MouseEvent) : void
      {
         this.soundProvider.play(AudioKeys.SOUND_MOUSE_DOWN);
         this._selectionRequested.dispatch(this,param1.ctrlKey,param1.shiftKey);
      }
      
      private function mouseOverHandler(param1:MouseEvent) : void
      {
         assignToolTip(this,this._model.displayName);
      }
      
      private function mouseOutHandler(param1:MouseEvent) : void
      {
         unassignToolTip(this);
      }
      
      override public function setData(param1:*) : void
      {
         super.setData(param1);
         this._model = param1 as SpellBookPageDTO;
         this.setLabelByIndex();
      }
      
      public function setLabelByIndex() : void
      {
         setText((this._index + 1).toString());
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
         this.setLabelByIndex();
      }
      
      public function getSelectionRequested() : ISignal
      {
         return this._selectionRequested;
      }
   }
}

