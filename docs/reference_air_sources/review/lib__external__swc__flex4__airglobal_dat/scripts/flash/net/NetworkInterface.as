package flash.net
{
   [Version("air2.0")]
   public class NetworkInterface
   {
      
      private var _name:String = "";
      
      private var _displayName:String = "";
      
      private var _addresses:Vector.<InterfaceAddress>;
      
      private var _mtu:int = -1;
      
      private var _hardwareAddress:String = "";
      
      private var _parent:NetworkInterface = null;
      
      private var _subInterfaces:Vector.<NetworkInterface>;
      
      private var _active:Boolean = false;
      
      public function NetworkInterface()
      {
         super();
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(value:String) : void
      {
         this._name = value;
      }
      
      public function get displayName() : String
      {
         return this._displayName;
      }
      
      public function set displayName(value:String) : void
      {
         this._displayName = value;
      }
      
      public function get addresses() : Vector.<InterfaceAddress>
      {
         return this._addresses;
      }
      
      public function set addresses(value:Vector.<InterfaceAddress>) : void
      {
         this._addresses = value;
      }
      
      public function get mtu() : int
      {
         return this._mtu;
      }
      
      public function set mtu(value:int) : void
      {
         this._mtu = value;
      }
      
      public function get hardwareAddress() : String
      {
         return this._hardwareAddress;
      }
      
      public function set hardwareAddress(value:String) : void
      {
         this._hardwareAddress = value;
      }
      
      public function get parent() : NetworkInterface
      {
         return this._parent;
      }
      
      public function set parent(value:NetworkInterface) : void
      {
         this._parent = value;
      }
      
      public function get subInterfaces() : Vector.<NetworkInterface>
      {
         return this._subInterfaces;
      }
      
      public function set subInterfaces(value:Vector.<NetworkInterface>) : void
      {
         this._subInterfaces = value;
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(value:Boolean) : void
      {
         this._active = value;
      }
   }
}

