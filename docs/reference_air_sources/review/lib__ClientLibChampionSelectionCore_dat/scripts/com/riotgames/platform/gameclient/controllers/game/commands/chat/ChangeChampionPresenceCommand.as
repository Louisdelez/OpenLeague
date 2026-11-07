package com.riotgames.platform.gameclient.controllers.game.commands.chat
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.chat.IPresenceProvider;
   import com.riotgames.platform.gameclient.domain.Champion;
   
   public class ChangeChampionPresenceCommand extends CommandBase
   {
      
      private var _champion:Champion;
      
      private var _presenceProvider:IPresenceProvider;
      
      public function ChangeChampionPresenceCommand(param1:Champion, param2:IPresenceProvider)
      {
         super(false);
         this._champion = param1;
         this._presenceProvider = param2;
      }
      
      override public function execute() : void
      {
         super.execute();
         if(this._champion == null)
         {
            this._presenceProvider.setSkinName(Champion.RANDOM_SKIN_NAME);
         }
         else
         {
            this._presenceProvider.setSkinName(this._champion.skinName);
         }
         onComplete();
         onResult();
      }
   }
}

