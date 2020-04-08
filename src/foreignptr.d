module foreignptr;

abstract
class ForeignPtr(T) {
	T __foreignPtr;
	alias __foreignPtr this;
}

private
class CTForeignPtr(alias deconstruct, T) : ForeignPtr!T {
	this(T ptr) {
		this.__foreignPtr = ptr;
	}
	~this() {
		deconstruct(__foreignPtr);
	}
}
private
class RTForeignPtr(T) : ForeignPtr!T {
	 void delegate(T) __deconstruct;
	this(T ptr, void delegate(T) deconstruct;) {
		this.__foreignPtr = ptr;
		this.__deconstruct = __deconstruct;
	}
	~this() {
		this.__deconstruct(__foreignPtr);
	}
}

ForeignPtr!T foreignPtr(alias deconstruct, T)(T ptr) {
	return new CTForeignPtr!(deconstruct, T)(ptr);
}

ForeignPtr!T foreignPtr(T)(T ptr, void delegate(T) deconstruct) {
	return new RTForeignPtr!T(ptr, deconstruct);
} 
ForeignPtr!T foreignPtr(T)(void delegate(T) deconstruct, T ptr) {
	return new RTForeignPtr!T(ptr, deconstruct);
} 
ForeignPtr!T
delegate(void delegate(T))
foreignPtr(T)(T ptr) {
	return deconstruct => new RTForeignPtr!T(ptr, deconstruct);
} 
ForeignPtr!T
delegate(T)
foreignPtr(T)(void delegate(T) deconstruct) {
	return ptr => new NewForeignPtr(ptr, deconstruct);
} 

