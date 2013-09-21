package pl.fabrykagier.totempotem.collections 
{
	public class Stack 
	{
		private var head:StackNode;
		private var tail:StackNode;
 
		public function push(obj:Object):void
		{
			var newNode:StackNode = new StackNode(obj);
 
			if(head == null)
				head = newNode;
			else
				tail.next = newNode;
 
			tail = newNode;
		}
 
		public function pop():Object
		{
			var result:StackNode = head;
 
			if(result != null)
			{
				// If there's no next, the tail should be nulled too as it's == head
				if(head.next == null)
					tail = null;
				head = head.next;
 
				return result.value;
			}
			else
				return null;
		}
 
		public function peek():Object
		{
			if(head != null)
				return head.value;
			else
				return null;
		}
		
	}
}