package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.gameclient.domain.GameItem;
   
   public class GameItemRendererFactory
   {
      
      private var inventoryController:IInventoryController;
      
      public function GameItemRendererFactory(param1:IInventoryController)
      {
         super();
         this.inventoryController = param1;
      }
      
      public function getRenderer(param1:Object) : GameItemRenderer
      {
         var _loc2_:GameItemRenderer = new GameItemRenderer();
         var _loc3_:GameItem = param1 as GameItem;
         if(!_loc3_ && param1 is Number)
         {
            _loc3_ = this.inventoryController.findGameItemDefinitionbyId(param1 as Number);
            _loc2_.alpha = 1;
            _loc2_.mouseEnabled = true;
            _loc2_.mouseChildren = true;
         }
         else if(param1 == GameItemRenderer.EMPTY_ITEM_SLOT)
         {
            _loc3_ = new GameItem();
            _loc3_.iconName = GameItemRenderer.EMPTY_ITEM_SLOT;
            _loc2_.alpha = 0.3;
            _loc2_.mouseEnabled = false;
            _loc2_.mouseChildren = false;
         }
         _loc2_.data = _loc3_;
         return _loc2_;
      }
   }
}

