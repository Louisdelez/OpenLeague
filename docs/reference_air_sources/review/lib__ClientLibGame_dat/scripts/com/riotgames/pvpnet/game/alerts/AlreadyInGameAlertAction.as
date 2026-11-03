package com.riotgames.pvpnet.game.alerts
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.domain.game.matched.FailedJoinPlayer;
   import com.riotgames.platform.gameclient.domain.game.matched.QueueDodger;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import mx.collections.ArrayCollection;
   import mx.resources.ResourceManager;
   
   public class AlreadyInGameAlertAction extends BasicAction
   {
      
      public function AlreadyInGameAlertAction()
      {
         super(true);
      }
      
      private static function createGrammaticallyCorrectNamesString(param1:String, param2:String, param3:Array) : String
      {
         var _loc8_:String = null;
         var _loc4_:String = "";
         var _loc5_:String = "";
         var _loc6_:String = "";
         var _loc7_:int = 0;
         while(_loc7_ < param3.length)
         {
            _loc4_ += _loc5_;
            _loc4_ += _loc6_;
            _loc8_ = param3[_loc7_] as String;
            _loc4_ += _loc8_;
            if(_loc7_ == param3.length - 2)
            {
               _loc6_ = " " + param1 + " ";
               _loc5_ = "";
            }
            else
            {
               _loc5_ = param2 + " ";
               _loc6_ = "";
            }
            _loc7_++;
         }
         return _loc4_;
      }
      
      final public function add(param1:ArrayCollection) : void
      {
         var _loc2_:String = null;
         var _loc3_:AlertAction = null;
         if(getIsFinished())
         {
            reset();
         }
         if(param1 != null && param1.length > 0)
         {
            _loc2_ = this.getInformationalMessage(param1);
            _loc3_ = new AlertAction(ResourceManager.getInstance().getString("resources","matchmaking_joinqueue_user_already_in_game_title"),_loc2_);
            _loc3_.add();
         }
      }
      
      private function getInformationalMessage(param1:ArrayCollection) : String
      {
         var _loc2_:String = "";
         if(param1.length > 1)
         {
            _loc2_ = ResourceManager.getInstance().getString("resources","matchmaking_joinqueue_many_already_in_game",new Array(this.createInGameNames(param1)));
         }
         else if(param1[0] != null && param1[0].summoner != null)
         {
            if(param1[0].summoner.internalName == Session.instance.summoner.internalName)
            {
               _loc2_ = ResourceManager.getInstance().getString("resources","matchmaking_joinqueue_you_already_in_game");
            }
            else
            {
               _loc2_ = ResourceManager.getInstance().getString("resources","matchmaking_joinqueue_user_already_in_game",new Array(param1[0].summoner.name));
            }
         }
         return _loc2_;
      }
      
      private function createInGameNames(param1:ArrayCollection) : String
      {
         var _loc6_:FailedJoinPlayer = null;
         var _loc7_:String = null;
         var _loc2_:String = ResourceManager.getInstance().getString("resources","matchmaking_joinqueue_and");
         var _loc3_:String = ResourceManager.getInstance().getString("resources","matchmaking_joinqueue_comma");
         var _loc4_:String = ResourceManager.getInstance().getString("resources","matchmaking_joinqueue_you");
         var _loc5_:Array = new Array();
         for each(_loc6_ in param1)
         {
            if(!(_loc6_ is QueueDodger))
            {
               _loc7_ = _loc6_.summoner.internalName == Session.instance.summoner.internalName ? _loc4_ : _loc6_.summoner.name;
               _loc5_.push(_loc7_);
            }
         }
         return createGrammaticallyCorrectNamesString(_loc2_,_loc3_,_loc5_);
      }
   }
}

