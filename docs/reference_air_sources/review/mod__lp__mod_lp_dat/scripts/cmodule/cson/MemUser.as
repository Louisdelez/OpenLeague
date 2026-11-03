package cmodule.cson
{
   public class MemUser
   {
      
      public function MemUser()
      {
         super();
      }
      
      final public function _mrd(param1:int) : Number
      {
         cmodule.cson.gstate.ds.position = param1;
         return cmodule.cson.gstate.ds.readDouble();
      }
      
      final public function _mrf(param1:int) : Number
      {
         cmodule.cson.gstate.ds.position = param1;
         return cmodule.cson.gstate.ds.readFloat();
      }
      
      final public function _mr32(param1:int) : int
      {
         cmodule.cson.gstate.ds.position = param1;
         return cmodule.cson.gstate.ds.readInt();
      }
      
      final public function _mru8(param1:int) : int
      {
         cmodule.cson.gstate.ds.position = param1;
         return cmodule.cson.gstate.ds.readUnsignedByte();
      }
      
      final public function _mw32(param1:int, param2:int) : void
      {
         cmodule.cson.gstate.ds.position = param1;
         cmodule.cson.gstate.ds.writeInt(param2);
      }
      
      final public function _mrs8(param1:int) : int
      {
         cmodule.cson.gstate.ds.position = param1;
         return cmodule.cson.gstate.ds.readByte();
      }
      
      final public function _mw16(param1:int, param2:int) : void
      {
         cmodule.cson.gstate.ds.position = param1;
         cmodule.cson.gstate.ds.writeShort(param2);
      }
      
      final public function _mw8(param1:int, param2:int) : void
      {
         cmodule.cson.gstate.ds.position = param1;
         cmodule.cson.gstate.ds.writeByte(param2);
      }
      
      final public function _mrs16(param1:int) : int
      {
         cmodule.cson.gstate.ds.position = param1;
         return cmodule.cson.gstate.ds.readShort();
      }
      
      final public function _mru16(param1:int) : int
      {
         cmodule.cson.gstate.ds.position = param1;
         return cmodule.cson.gstate.ds.readUnsignedShort();
      }
      
      final public function _mwd(param1:int, param2:Number) : void
      {
         cmodule.cson.gstate.ds.position = param1;
         cmodule.cson.gstate.ds.writeDouble(param2);
      }
      
      final public function _mwf(param1:int, param2:Number) : void
      {
         cmodule.cson.gstate.ds.position = param1;
         cmodule.cson.gstate.ds.writeFloat(param2);
      }
   }
}

