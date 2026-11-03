package com.riotgames.platform.gameclient.chat.utils
{
   import org.igniterealtime.xiff.data.Presence;
   
   public class RiotPresence
   {
      
      public static const CHAT:RiotPresence = new RiotPresence("CHAT","available",GREEN);
      
      public static const MOBILE:RiotPresence = new RiotPresence("MOBILE","m",BLUE);
      
      public static const AWAY:RiotPresence = new RiotPresence("AWAY","away",RED);
      
      public static const DND:RiotPresence = new RiotPresence("DND","busy",YELLOW);
      
      public static const OFFLINE:RiotPresence = new RiotPresence("OFFLINE","offline",GREY);
      
      private static const GREEN:uint = 4502840;
      
      private static const YELLOW:uint = 15914309;
      
      private static const RED:uint = 12980992;
      
      private static const BLUE:uint = 1737193;
      
      private static const GREY:uint = 8684676;
      
      private var _color:uint;
      
      private var _name:String;
      
      private var _assetKey:String;
      
      public function RiotPresence(param1:String, param2:String, param3:uint)
      {
         super();
         this._name = param1;
         this._assetKey = param2;
         this._color = param3;
      }
      
      private static function overrideMobilePresence(param1:String, param2:Boolean) : String
      {
         if(!param2 && param1 == Presence.SHOW_CHAT_MOBILE)
         {
            return Presence.SHOW_AWAY;
         }
         return param1;
      }
      
      public static function fromXiffPresence(param1:String, param2:Boolean = false) : RiotPresence
      {
         param1 = overrideMobilePresence(param1,param2);
         switch(param1)
         {
            case Presence.SHOW_DND:
               return DND;
            case Presence.SHOW_CHAT_MOBILE:
               return MOBILE;
            case Presence.SHOW_AWAY:
               return AWAY;
            case Presence.SHOW_OFFLINE:
               return OFFLINE;
            case Presence.SHOW_CHAT:
         }
         return CHAT;
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get assetKey() : String
      {
         return this._assetKey;
      }
      
      public function get colorHex() : String
      {
         return "#" + this._color.toString(16);
      }
   }
}

