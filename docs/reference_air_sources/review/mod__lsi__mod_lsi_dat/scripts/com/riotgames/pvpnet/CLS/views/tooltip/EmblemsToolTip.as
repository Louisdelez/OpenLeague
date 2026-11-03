package com.riotgames.pvpnet.CLS.views.tooltip
{
   import blix.components.renderer.IDataRenderer;
   import blix.components.timeline.StatefulView;
   import blix.context.Context;
   import com.riotgames.pvpnet.CLS.models.EmblemModel;
   import flash.display.MovieClip;
   
   public class EmblemsToolTip extends StatefulView implements IDataRenderer
   {
      
      protected const HORIZONTAL_PADDING:Number = 20;
      
      protected const HORIZONTAL_SIZER:Number = 1.2;
      
      protected var _model:EmblemModel;
      
      public function EmblemsToolTip(param1:Context, param2:MovieClip = null)
      {
         super(param1,param2);
         setMouseEnabled(false);
         setMouseChildren(false);
      }
      
      public function getData() : *
      {
         return this._model;
      }
      
      public function setData(param1:*) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(!(param1 is EmblemModel))
         {
            throw new ArgumentError("data property must be of type EmblemsModel");
         }
         this._model = param1 as EmblemModel;
         this.updateUI();
      }
      
      protected function updateUI() : void
      {
      }
   }
}

