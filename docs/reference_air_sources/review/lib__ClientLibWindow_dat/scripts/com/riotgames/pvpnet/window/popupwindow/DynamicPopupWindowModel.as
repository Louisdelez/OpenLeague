package com.riotgames.pvpnet.window.popupwindow
{
   import blix.assets.proxy.SpriteProxy;
   
   public class DynamicPopupWindowModel
   {
      
      public static const VECTICAL_EXPAND:String = "VECTICAL_EXPAND";
      
      public static const HORIZONTAL_EXPAND:String = "HORIZONTAL_EXPAND";
      
      public static const BOTH_DIRECTION_EXPAND:String = "BOTH_DIRECTION_EXPAND";
      
      public static const ARROW_POSITION_TOP:String = "ARROW_POSITION_TOP";
      
      public static const ARROW_POSITION_BOT:String = "ARROW_POSITION_BOT";
      
      public static const ARROW_POSITION_LEFT:String = "ARROW_POSITION_LEFT";
      
      public static const ARROW_POSITION_RIGHT:String = "ARROW_POSITION_RIGHT";
      
      public static const WINDOW_POSITION_LEFT:String = "WINDOW_POSITION_LEFT";
      
      public static const WINDOW_POSITION_RIGHT:String = "WINDOW_POSITION_RIGHT";
      
      public static const WINDOW_POSITION_TOP:String = "WINDOW_POSITION_TOP";
      
      public static const WINDOW_POSITION_BOT:String = "WINDOW_POSITION_BOT";
      
      public static const LOCK_TOP_LEFT_CORNER:String = "LOCK_TOP_LEFT_CORNER";
      
      public static const LOCK_TOP_RIGHT_CORNER:String = "LOCK_TOP_RIGHT_CORNER";
      
      public static const LOCK_BOT_LEFT_CORNER:String = "LOCK_BOT_LEFT_CORNER";
      
      public static const LOCK_BOT_RIGHT_CORNER:String = "LOCK_BOT_RIGHT_CORNER";
      
      private var _target:SpriteProxy;
      
      private var _horizontalPositionOffset:Number = 0;
      
      private var _calculateHorizontalFromLeftSide:Boolean = true;
      
      private var _verticalPositionOffset:Number = 0;
      
      private var _calculateVecticalFromTop:Boolean = true;
      
      private var _alignToTargetCenter:Boolean = true;
      
      private var _expandMode:String = "BOTH_DIRECTION_EXPAND";
      
      private var _arrowPosition:String = "ARROW_POSITION_TOP";
      
      private var _lockCornerMode:Boolean;
      
      private var _widthRelativePosition:String;
      
      public function DynamicPopupWindowModel(param1:SpriteProxy)
      {
         super();
         this._target = param1;
      }
      
      public function get target() : SpriteProxy
      {
         return this._target;
      }
      
      public function set target(param1:SpriteProxy) : void
      {
         this._target = param1;
      }
      
      public function get horizontalPositionOffset() : Number
      {
         return this._horizontalPositionOffset;
      }
      
      public function set lockedCornerHorizontalPosition(param1:Number) : void
      {
         this._horizontalPositionOffset = param1;
      }
      
      public function get calculateHorizontalFromLeftSide() : Boolean
      {
         return this._calculateHorizontalFromLeftSide;
      }
      
      public function get verticalPositionOffset() : Number
      {
         return this._verticalPositionOffset;
      }
      
      public function set lockedCornerVerticalPosition(param1:Number) : void
      {
         this._verticalPositionOffset = param1;
      }
      
      public function get calculateVecticalFromTop() : Boolean
      {
         return this._calculateVecticalFromTop;
      }
      
      public function get alignToTargetCenter() : Boolean
      {
         return this._alignToTargetCenter;
      }
      
      public function set alignToTargetCenter(param1:Boolean) : void
      {
         this._alignToTargetCenter = param1;
      }
      
      public function get expandMode() : String
      {
         return this._expandMode;
      }
      
      public function set expandMode(param1:String) : void
      {
         this._expandMode = param1;
      }
      
      public function get arrowPosition() : String
      {
         return this._arrowPosition;
      }
      
      public function set arrowPosition(param1:String) : void
      {
         this._arrowPosition = param1;
      }
      
      public function set lockCorner(param1:String) : void
      {
         this._widthRelativePosition = "";
         this._lockCornerMode = true;
         switch(param1)
         {
            case LOCK_TOP_LEFT_CORNER:
               this._calculateVecticalFromTop = true;
               this._calculateHorizontalFromLeftSide = true;
               break;
            case LOCK_TOP_RIGHT_CORNER:
               this._calculateVecticalFromTop = true;
               this._calculateHorizontalFromLeftSide = false;
               break;
            case LOCK_BOT_LEFT_CORNER:
               this._calculateVecticalFromTop = false;
               this._calculateHorizontalFromLeftSide = true;
               break;
            case LOCK_BOT_RIGHT_CORNER:
               this._calculateVecticalFromTop = false;
               this._calculateHorizontalFromLeftSide = false;
         }
      }
      
      public function set windowPositionRelativeToTarget(param1:String) : void
      {
         this._lockCornerMode = false;
         this._widthRelativePosition = param1;
         switch(this._widthRelativePosition)
         {
            case WINDOW_POSITION_LEFT:
               this._arrowPosition = ARROW_POSITION_RIGHT;
               break;
            case WINDOW_POSITION_RIGHT:
               this._arrowPosition = ARROW_POSITION_LEFT;
               break;
            case WINDOW_POSITION_TOP:
               this._arrowPosition = ARROW_POSITION_BOT;
               break;
            case WINDOW_POSITION_BOT:
               this._arrowPosition = ARROW_POSITION_TOP;
         }
      }
      
      public function get lockCornerMode() : Boolean
      {
         return this._lockCornerMode;
      }
      
      public function get widthRelativePosition() : String
      {
         return this._widthRelativePosition;
      }
      
      public function getAlignHorizontal() : Boolean
      {
         var _loc1_:Boolean = false;
         return this._widthRelativePosition == WINDOW_POSITION_TOP || this._widthRelativePosition == WINDOW_POSITION_BOT;
      }
      
      public function getAlignVertical() : Boolean
      {
         var _loc1_:Boolean = false;
         return this._widthRelativePosition == WINDOW_POSITION_RIGHT || this._widthRelativePosition == WINDOW_POSITION_LEFT;
      }
   }
}

