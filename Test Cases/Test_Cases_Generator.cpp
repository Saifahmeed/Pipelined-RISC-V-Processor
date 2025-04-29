#include <bits/stdc++.h>
using namespace std;
struct instruction {
    string name;
    char type;
};
string Reg[] = {
    "x0", "x1", "x2", "x3", "x4", "x5", "x6",
    "x7", "x8", "x9", "x10", "x11", "x12", "x13",
    "x14", "x15", "x16", "x17", "x18", "x19", "x20",
    "x21", "x22", "x23", "x24", "x25", "x26", "x27",
    "x28", "x29", "x30", "x31"
};
instruction Inst[] = {
    {"sb", 'S'},
    {"sh", 'S'},
    {"sw", 'S'},
    {"addi", 'I'},
    {"slti", 'I'},
    {"sltiu", 'I'},
    {"xori", 'I'},
    {"ori", 'I'},
    {"andi", 'I'},
    {"slli", 'I'},
    {"srli", 'I'},
    {"srai", 'I'},
    {"add", 'R'},
    {"sub", 'R'},
    {"sll", 'R'},
    {"slt", 'R'},
    {"sltu", 'R'},
    {"auipc", 'U'},
    {"xor", 'R'},
    {"srl", 'R'},
    {"sra", 'R'},
    {"or", 'R'},
    {"and", 'R'},
    {"mul", 'R'},
    {"mulh", 'R'},
    {"mulhsu", 'R'},
    {"mulhu", 'R'},
    {"div", 'R'},
    {"divu", 'R'},
    {"rem", 'R'},
    {"remu", 'R'},
    {"lui", 'U'},
    {"jal", 'J'},
    {"jalr", 'I'},
    {"beq", 'B'},
    {"bne", 'B'},
    {"blt", 'B'},
    {"bge", 'B'},
    {"bltu", 'B'},
    {"bgeu", 'B'},
    {"lb", 'L'},
    {"lh", 'L'},
    {"lw", 'L'},
    {"lbu", 'L'},
    {"lhu", 'L'},
    {"fence", 'Y'},
    {"ecall", 'Y'},
    {"ebreak", 'Y'},
};

void get_test(int inst_num) {
    freopen("TestCase.txt", "w", stdout);
    for (int i = 0; i < inst_num; ++i) {
        int inst_num = rand() % 40;
        instruction Ins = Inst[inst_num];
        int r1 = rand() % 32;
        int r2 = rand() % 32;
        int rd = rand() % 32;
        int imm = rand() % 100;
        int branchim = 4 * (rand() % (inst_num - i) + 1);   // branch to a random inst less than the last one
        if (Ins.type == 'R') {
            cout << Ins.name << " " << Reg[rd] << ", " << Reg[r1] << ", " << Reg[r2];
        }
        else if (Ins.type == 'I') {
            cout << Ins.name << " " << Reg[rd] << ", " << Reg[r1] << ", " << imm;
        }
        else if (Ins.type == 'S') {
            cout << Ins.name << " " << Reg[r1] << ", " << imm << "(" << Reg[r2] << ")";
        }
        else if (Ins.type == 'B') {
            cout << Ins.name << " " << Reg[r1] << ", " << Reg[r2] << ", " << branchim;
        }
        else if (Ins.type == 'U') {
            cout << Ins.name << " " << Reg[rd] << ", " << imm;
        }
        else if (Ins.type == 'J') {
            cout << Ins.name << " " << Reg[rd] << ", " << branchim;
        }
        else if (Ins.type == 'L') {
            cout << Ins.name << " " << Reg[rd] << ", " << imm << "(" << Reg[r1] << ")";
        }
        else if (Ins.type == 'Y') {
            cout << Ins.name;
        }
        cout << endl;
    }
}
int main() {
    int inst_num;
    cout << "How many instructions to generate: ";
    cin >> inst_num;
    get_test(inst_num);
}