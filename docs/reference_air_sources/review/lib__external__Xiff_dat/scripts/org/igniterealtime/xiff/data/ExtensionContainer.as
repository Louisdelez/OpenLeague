package org.igniterealtime.xiff.data
{
   public class ExtensionContainer implements IExtendable
   {
      
      public var _exts:Object;
      
      public function ExtensionContainer()
      {
         super();
         this._exts = new Object();
      }
      
      public function addExtension(param1:IExtension) : IExtension
      {
         if(this._exts[param1.getNS()] == null)
         {
            this._exts[param1.getNS()] = new Array();
         }
         this._exts[param1.getNS()].push(param1);
         return param1;
      }
      
      public function removeExtension(param1:IExtension) : Boolean
      {
         var _loc3_:String = null;
         var _loc2_:Object = this._exts[param1.getNS()];
         for(_loc3_ in _loc2_)
         {
            if(_loc2_[_loc3_] === param1)
            {
               _loc2_[_loc3_].remove();
               _loc2_.splice(Number(_loc3_),1);
               return true;
            }
         }
         return false;
      }
      
      public function removeAllExtensions(param1:String) : void
      {
         var _loc2_:String = null;
         for(_loc2_ in this._exts[param1])
         {
            this._exts[param1][_loc2_].ns();
         }
         this._exts[param1] = new Array();
      }
      
      public function getAllExtensionsByNS(param1:String) : Array
      {
         return this._exts[param1];
      }
      
      public function getExtension(param1:String) : Extension
      {
         var name:String = param1;
         return this.getAllExtensions().filter(function(param1:IExtension, param2:int, param3:Array):Boolean
         {
            return param1.getElementName() == name;
         })[0];
      }
      
      public function getAllExtensions() : Array
      {
         var _loc2_:String = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in this._exts)
         {
            _loc1_ = _loc1_.concat(this._exts[_loc2_]);
         }
         return _loc1_;
      }
   }
}

