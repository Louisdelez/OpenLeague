package com.riotgames.platform.gameclient.controllers.game.views.voting.allteam
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.platform.common.utils.ChampionIconCacheUtil;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class VoteRendererUtils
   {
      
      public static const STATE_MINE_LOCKED:String = "lockedmine";
      
      public static const STATE_LOCKED:String = "locked";
      
      public static const STATE_NOT_LOCKED:String = "notlocked";
      
      public static const STATE_MINE_NOT_LOCKED:String = "notlockedmine";
      
      public static const STATE_WINNER:String = "winner";
      
      public static const STATE_LOSER:String = "loser";
      
      public function VoteRendererUtils()
      {
         super();
      }
      
      public static function createIconImage(param1:IContext, param2:VoteItem) : MovieClipProxy
      {
         var _loc3_:MovieClipProxy = new MovieClipProxy(param1);
         _loc3_.setLinkage("ChampIcon");
         return _loc3_;
      }
      
      public static function updateIconImageTile(param1:MovieClipProxy, param2:VoteItem) : void
      {
         var _loc3_:BitmapData = null;
         _loc3_ = ChampionIconCacheUtil.instance.getIcon(param2.champion.skinName);
         var _loc4_:Number = Math.max(60 / _loc3_.width,60 / _loc3_.height);
         var _loc5_:Matrix = new Matrix();
         _loc5_.scale(_loc4_,_loc4_);
         _loc5_.translate(0,0);
         var _loc6_:BitmapData = new BitmapData(60,60,false,16777215);
         _loc6_.draw(_loc3_,_loc5_,null,null,null,true);
         var _loc7_:Bitmap = new Bitmap(_loc6_);
         var _loc8_:BitmapProxy = new BitmapProxy(param1,_loc7_);
         param1.addChild(_loc8_);
         _loc8_.setSmoothing(true);
      }
      
      public static function updateIconState(param1:StatefulView, param2:VoteItem) : void
      {
         if(param2 == null)
         {
            return;
         }
         if(param2.winner)
         {
            param1.setCurrentState(VoteRendererUtils.STATE_WINNER);
         }
         else if(param2.allVotingComplete)
         {
            param1.setCurrentState(VoteRendererUtils.STATE_LOSER);
         }
         else if(param2.mine)
         {
            param1.setCurrentState(param2.locked ? VoteRendererUtils.STATE_MINE_LOCKED : VoteRendererUtils.STATE_MINE_NOT_LOCKED);
         }
         else
         {
            param1.setCurrentState(param2.locked ? VoteRendererUtils.STATE_LOCKED : VoteRendererUtils.STATE_NOT_LOCKED);
         }
      }
      
      public static function updateIconImage(param1:MovieClipProxy, param2:VoteItem) : void
      {
         var _loc3_:BitmapData = null;
         var _loc4_:Bitmap = null;
         var _loc5_:BitmapProxy = null;
         if(param2 != null)
         {
            _loc3_ = ChampionIconCacheUtil.instance.getIcon(param2.champion.skinName);
            _loc4_ = new Bitmap(_loc3_);
            _loc4_.width = 60;
            _loc4_.height = 60;
            _loc4_.x = param2.abstain ? 5 : 0;
            _loc4_.y = param2.abstain ? 5 : 0;
            _loc5_ = new BitmapProxy(param1,_loc4_);
            param1.addChild(_loc5_);
            _loc5_.setSmoothing(true);
         }
      }
      
      public static function updatePercentChance(param1:TextFieldProxy, param2:VoteItem) : void
      {
         if(param2 != null)
         {
            if(param2.locked && !param2.abstain && !param2.winnerDecided)
            {
               param1.setText(RiotResourceLoader.getString("champSelect_voting_percent",null,[param2.chance]));
               param1.setVisible(true);
            }
            else
            {
               param1.setVisible(false);
            }
         }
      }
   }
}

