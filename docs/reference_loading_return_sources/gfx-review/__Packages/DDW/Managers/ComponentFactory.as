class DDW.Managers.ComponentFactory
{
   static var _instance;
   var componentFactories = [];
   function ComponentFactory(s)
   {
      if(s != "use getInstance")
      {
         throw new Error("ComponentFactory is a singleton object. Use ComponentFactory.getInstance");
      }
   }
   static function getInstance()
   {
      if(_instance == null)
      {
         _instance = new DDW.Managers.ComponentFactory("use getInstance");
      }
      return _instance;
   }
   function addComponent(comp)
   {
      this.componentFactories.push(comp);
   }
   function createInstance(type, libName, mx)
   {
      var _loc5_ = null;
      var _loc6_;
      switch(type)
      {
         case "DisplayObject":
            _loc5_ = new DDW.Components.DisplayObject(libName,mx);
            break;
         case "DisplayObjectContainer":
            _loc5_ = new DDW.Components.DisplayObjectContainer(libName,mx);
            break;
         case "DefaultButton":
            _loc5_ = new DDW.Components.DefaultButton(libName,mx);
            break;
         case "ToggleButton":
            _loc5_ = new DDW.Components.ToggleButton(libName,mx);
            break;
         case "DefaultTextBox":
            _loc5_ = new DDW.Components.DefaultTextBox(libName,mx);
            break;
         case "DefaultProgressBar":
            _loc5_ = new DDW.Components.DefaultProgressBar(libName,mx);
            break;
         case "DrawnProgressBar":
            _loc5_ = new DDW.Components.DrawnProgressBar(libName,mx);
            break;
         case "TextProgressBar":
            _loc5_ = new DDW.Components.TextProgressBar(libName,mx);
            break;
         default:
            _loc6_ = 0;
            while(_loc6_ < this.componentFactories.length)
            {
               _loc5_ = this.componentFactories[_loc6_].createInstance(type,libName,mx);
               if(_loc5_ != null)
               {
                  break;
               }
               _loc6_ = _loc6_ + 1;
            }
      }
      return _loc5_;
   }
}
