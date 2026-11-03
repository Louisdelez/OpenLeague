package com.riotgames.platform.gameclient.kudos.iron
{
   import blix.assets.IAssetsManager;
   
   public class IronKudosButtonDisabled extends IronKudosButtonEnabled
   {
      
      public function IronKudosButtonDisabled(param1:IAssetsManager)
      {
         super(param1,false,0,null,0,null);
         enabled = false;
      }
   }
}

