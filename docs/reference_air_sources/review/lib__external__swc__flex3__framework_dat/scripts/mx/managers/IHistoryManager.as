package mx.managers
{
   [ExcludeClass]
   public interface IHistoryManager
   {
      
      [Deprecated(since="3.0.0")]
      function registered() : void;
      
      function register(param1:IHistoryManagerClient) : void;
      
      [Deprecated(since="3.0.0")]
      function registerHandshake() : void;
      
      [Deprecated(since="3.0.0")]
      function load(param1:Object) : void;
      
      [Deprecated(since="3.0.0")]
      function loadInitialState() : void;
      
      function unregister(param1:IHistoryManagerClient) : void;
      
      function save() : void;
   }
}

