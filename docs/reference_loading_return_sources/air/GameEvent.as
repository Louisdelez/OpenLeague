package com.riotgames.platform.gameclient.championselection
{
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import flash.events.Event;
   
   public class GameEvent extends Event
   {
      
      public static const ABORT_CHAMPION_SELECTION:String = "abortChampionSelection";
      
      public static const END_CHAMPION_SELECTION:String = "endChampionSelection";
      
      public static const BROWSE_REQUESTED:String = "browseRequested";
      
      public static const COMPLETE_CHAMPION_SELECT:String = "completeChampionSelect";
      
      public static const COMPLETE_LOAD_SCREEN:String = "completeLoadScreen";
      
      private var _game:GameDTO;
      
      private var _info:Object;
      
      public function GameEvent(param1:String, param2:GameDTO, param3:Object = null, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         this._game = param2;
         this._info = param3;
      }
      
      override public function clone() : Event
      {
         return new GameEvent(type,this.game,this.info,bubbles,cancelable);
      }
      
      public function get game() : GameDTO
      {
         return this._game;
      }
      
      public function get info() : Object
      {
         return this._info;
      }
   }
}

