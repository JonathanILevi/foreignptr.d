module refedforeignptr;

abstract
class ForeignPtr(T) {
	T __foreignPtr;
	alias __foreignPtr this;
}

private
class CTForeignPtr(alias deconstruct, T, HoldPtrs...) : ForeignPtr!T {
	HoldPtrs holdPtrs;
	this(T ptr, HoldPtrs holdPtrs) {
		this.__foreignPtr = ptr;
		this.holdPtrs = holdPtrs;
	}
	~this() {
		deconstruct(__foreignPtr);
	}
}
private
class RTDForeignPtr(T, HoldPtrs...) : ForeignPtr!T {
	 void delegate(T) deconstruct;
	HoldPtrs holdPtrs;
	this(T ptr, void delegate(T) deconstruct, HoldPtrs holdPtrs) {
		this.__foreignPtr = ptr;
		this.deconstruct = deconstruct;
		this.holdPtrs = holdPtrs;
	}
	~this() {
		this.deconstruct(__foreignPtr);
	}
}
private
class RTFForeignPtr(T, HoldPtrs...) : ForeignPtr!T {
	 void function(T) deconstruct;
	HoldPtrs holdPtrs;
	this(T ptr, void function(T) deconstruct, HoldPtrs holdPtrs) {
		this.__foreignPtr = ptr;
		this.deconstruct = deconstruct;
		this.holdPtrs = holdPtrs;
	}
	~this() {
		this.deconstruct(__foreignPtr);
	}
}

ForeignPtr!T foreignPtr(alias deconstruct, T, HoldPtrs...)(T ptr, HoldPtrs holdPtrs) {
	return new CTForeignPtr!(deconstruct, T, HoldPtrs)(ptr, holdPtrs);
}

ForeignPtr!T foreignPtr(T, HoldPtrs...)(void delegate(T) deconstruct, T ptr, HoldPtrs holdPtrs) {
	return new RTDForeignPtr!(T, HoldPtrs)(ptr, deconstruct, holdPtrs);
} 
ForeignPtr!T foreignPtr(T, HoldPtrs...)(void function(T) deconstruct, T ptr, HoldPtrs holdPtrs) {
	return new RTFForeignPtr!(T, HoldPtrs)(ptr, deconstruct, holdPtrs);
} 
////ForeignPtr!T foreignPtr(T)(T ptr, void delegate(T) deconstruct) {
////	return new RTForeignPtr!T(ptr, deconstruct);
////} 
////ForeignPtr!T
////delegate(void delegate(T))
////foreignPtr(T)(T ptr) {
////	return deconstruct => new RTForeignPtr!T(ptr, deconstruct);
////} 
////ForeignPtr!T
////delegate(T)
////foreignPtr(T)(void delegate(T) deconstruct) {
////	return ptr => new NewForeignPtr(ptr, deconstruct);
////} 

