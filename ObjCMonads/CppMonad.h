//
//  CppMonad.h
//  ObjCMonads
//
//  Created by Tamas Lustyik on 2014.04.05..
//  Copyright (c) 2014 LKXF. All rights reserved.
//

#ifndef __ObjCMonads__CppMonad__
#define __ObjCMonads__CppMonad__

#include <functional>
/*
namespace cpp {

    class IMonad;
    
//    typedef IMonad const* MonadicValue;
//    typedef std::function<MonadicValue(void*)> MContinuation;
    
    class IMonad {
    protected:
        typedef IMonad const* MonadicValue;
        typedef std::function<MonadicValue(void*)> Continuation;

    public:
        virtual MonadicValue bind(Continuation) const = 0;
        virtual MonadicValue bind_(MonadicValue mv) const {
            std::remove_reference<MonadicValue>::type tmp = mv;
            auto cont = [tmp](void*) -> MonadicValue {
                return tmp;
            };
            return bind(cont);
        }
        virtual MonadicValue unit(void*) const = 0;
    };

    class Maybe: public IMonad {
    private:
        void* _value;
        bool _isJust;
        
    public:
        Maybe(): _value(nullptr), _isJust(false) {}
        Maybe(void* value): _value(value), _isJust(true) {}
    
    public:
        MonadicValue bind(Continuation cont) const {
            if (_isJust) {
                return cont(_value);
            }
            return Maybe();
        }
        
        MonadicValue unit(void* value) {
            return Maybe(value);
        }
    };
}
*/
    
#endif /* defined(__ObjCMonads__CppMonad__) */
