#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/classes/global_constants.hpp>
#include <godot_cpp/godot.hpp>

using namespace godot;

class MyLib : public Object {
    GDCLASS(MyLib, Object);

protected:
    static void _bind_methods() {
        ClassDB::bind_method(D_METHOD("add_numbers", "a", "b"), &MyLib::add_numbers);
        ClassDB::bind_method(D_METHOD("print_hello"), &MyLib::print_hello);
    }

public:
    int add_numbers(int a, int b) {
        return a + b;
    }

    void print_hello() {
        Godot::print("Hello from GDExtension!");
    }
};

extern "C" {
    GDExtensionBool GDE_EXPORT mylib_init(
        GDExtensionInterfaceGetProcAddress p_get_proc_address,
        GDExtensionClassLibraryPtr p_library,
        GDExtensionInitialization *r_initialization
    ) {
        godot::GDExtensionBinding::InitObject init_obj(p_get_proc_address, p_library, r_initialization);
        init_obj.register_initializer([]() {
            ClassDB::register_class<MyLib>();
        });
        return init_obj.init();
    }
}