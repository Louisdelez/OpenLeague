package com.riotgames.pvpnet.cap.views.popups
{
   import blix.context.IContext;
   import blix.layout.data.CanvasLayoutData;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.model.IPlayerSpellModel;
   import com.riotgames.pvpnet.cap.model.ISpellModel;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.views.spells.CapSpellSelectionViewBase;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class CapSpellSelectionView extends CapSpellSelectionViewBase
   {
      
      private var soundProvider:ISoundProvider;
      
      private var model:CapModel;
      
      private var playerSelection:IPlayerSpellModel;
      
      public function CapSpellSelectionView(param1:IContext, param2:int)
      {
         this.model = param1.getDependency(CapModel);
         this.playerSelection = this.model.localPlayerSelection as IPlayerSpellModel;
         super(param1,param2,this.model as ISpellModel,this.playerSelection);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.soundProvider = getDependency(ISoundProvider);
      }
      
      override protected function mouseClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:Rectangle = getBounds(getStage());
         var _loc3_:CanvasLayoutData = new CanvasLayoutData();
         _loc3_.setX(_loc2_.x);
         _loc3_.setY(_loc2_.y - 197);
         this.soundProvider.play(CapAudioKeys.CAP_OPEN_WINDOW);
         showPopup(createPopup(),_loc3_);
      }
   }
}

