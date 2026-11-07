package com.riotgames.platform.gameclient.module.services.local
{
   import com.riotgames.platform.gameclient.services.LocalGameDataService;
   
   public class LocalGameDataServiceImpl implements LocalGameDataService
   {
      
      private var _keybindingDAO:KeybindingDAO = null;
      
      public function LocalGameDataServiceImpl()
      {
         super();
      }
      
      public function getKeybindingDefaults(param1:String, param2:Function, param3:Function, param4:Function) : void
      {
         this.keybindingDAO(param1).getKeybindingDefaults(param2,param3,param4);
      }
      
      public function getKeybindingCategories(param1:String, param2:Function, param3:Function, param4:Function) : void
      {
         this.keybindingDAO(param1).getKeybindingCategories(param2,param3,param4);
      }
      
      private function keybindingDAO(param1:String) : KeybindingDAO
      {
         if(this._keybindingDAO == null)
         {
            this._keybindingDAO = new KeybindingDAO(param1);
         }
         return this._keybindingDAO;
      }
   }
}

