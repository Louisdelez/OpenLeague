package org.igniterealtime.xiff.data.whiteboard
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.ISerializable;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class Path implements ISerializable
   {
      
      public static var ELEMENT:String = "path";
      
      private var mySegments:Array;
      
      private var myStroke:Stroke;
      
      private var myFill:Fill;
      
      private var _lastLocation:Object;
      
      public function Path(param1:XMLNode = null)
      {
         super();
         this.mySegments = new Array();
         this.myStroke = new Stroke();
         this.myFill = new Fill();
      }
      
      private static function indexOfNextCommand(param1:String) : Number
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(param1.charAt(_loc2_) >= "A" && param1.charAt(_loc2_) <= "Z" || param1.charAt(_loc2_) >= "a" && param1.charAt(_loc2_) <= "z")
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = XMLStanza.XMLFactory.createElement(Path.ELEMENT);
         _loc2_.attributes["p"] = this.serializeSegments();
         this.stroke.serialize(_loc2_);
         this.fill.serialize(_loc2_);
         param1.appendChild(_loc2_);
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc2_:String = param1.attributes["p"];
         this.mySegments = new Array();
         this._lastLocation = new Object();
         this.loadNextCommand(_loc2_);
         this.myStroke = new Stroke();
         this.myStroke.deserialize(param1);
         this.myFill = new Fill();
         this.myFill.deserialize(param1);
         return true;
      }
      
      public function serializeSegments() : String
      {
         var _loc5_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:String = "";
         var _loc3_:Array = this.segments;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            if(_loc1_.to.x != _loc5_.from.x && _loc1_.to.y != _loc5_.from.y)
            {
               _loc2_ += "M" + _loc5_.from.x + " " + _loc5_.from.y + "l";
            }
            else
            {
               _loc2_ += " ";
            }
            _loc2_ += _loc5_.to.x - _loc5_.from.x + " " + (_loc5_.to.y - _loc5_.from.y);
            _loc1_ = _loc5_;
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function addSegment(param1:Object) : Object
      {
         param1.from.x = Math.round(param1.from.x);
         param1.from.y = Math.round(param1.from.y);
         param1.to.x = Math.round(param1.to.x);
         param1.to.y = Math.round(param1.to.y);
         if(Boolean(this.mySegments.addItem))
         {
            this.mySegments.addItem(param1);
         }
         else
         {
            this.mySegments.push(param1);
         }
         return param1;
      }
      
      public function addPoints(param1:Number, param2:Number, param3:Number, param4:Number) : Object
      {
         return this.addSegment({
            "from":{
               "x":param1,
               "y":param2
            },
            "to":{
               "x":param3,
               "y":param4
            }
         });
      }
      
      public function get segments() : Array
      {
         return this.mySegments;
      }
      
      public function get stroke() : Stroke
      {
         return this.myStroke;
      }
      
      public function get fill() : Fill
      {
         return this.myFill;
      }
      
      private function loadNextCommand(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc2_:Number = indexOfNextCommand(param1);
         if(_loc2_ >= 0)
         {
            _loc3_ = param1.charAt(_loc2_);
            _loc4_ = param1.split(_loc3_);
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(_loc4_[_loc5_].length > 0)
               {
                  this.loadCommand(_loc3_,_loc4_[_loc5_]);
               }
               _loc5_++;
            }
         }
      }
      
      private function loadCommand(param1:String, param2:String) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc3_:Number = indexOfNextCommand(param2);
         if(_loc3_ > 0)
         {
            _loc4_ = param2.slice(0,_loc3_).split(" ");
         }
         else
         {
            _loc4_ = param2.split(" ");
         }
         while(_loc4_.length > 0)
         {
            if(_loc4_[0].length == 0)
            {
               _loc4_.shift();
               continue;
            }
            switch(param1)
            {
               case "M":
                  this._lastLocation = {
                     "x":Number(_loc4_.shift()),
                     "y":Number(_loc4_.shift())
                  };
                  break;
               case "L":
                  _loc5_ = {
                     "x":Number(_loc4_.shift()),
                     "y":Number(_loc4_.shift())
                  };
                  this.addSegment({
                     "from":this._lastLocation,
                     "to":_loc5_
                  });
                  this._lastLocation = _loc5_;
                  break;
               case "l":
                  _loc5_ = {
                     "x":this._lastLocation.x + Number(_loc4_.shift()),
                     "y":this._lastLocation.y + Number(_loc4_.shift())
                  };
                  this.addSegment({
                     "from":this._lastLocation,
                     "to":_loc5_
                  });
                  this._lastLocation = _loc5_;
                  break;
               default:
                  _loc4_.shift();
            }
         }
         this.loadNextCommand(param2.slice(_loc3_));
      }
   }
}

