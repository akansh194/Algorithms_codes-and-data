# Linked List
mutable struct Node
    data::Dict{String, String}
    next::Union{Node, Nothing}
    Node(data) = new(data, nothing)
end


mutable struct MemoryDB_bubble
    head::Union{Node, Nothing}
    headers::Vector{String}
    MemoryDB_bubble() = new(nothing, String[])
end

function get_data!(db::MemoryDB_bubble, filename::String)
    open(filename, "r") do io
        lines = readlines(io)
        db.headers = split(lines[1], ",")
        for i in 2:length(lines)
            row = split(lines[i], ",")
            row_dict = Dict(db.headers[j] => row[j] for j in 1:length(db.headers))
            insert!(db, row_dict)
        end
    end
end

function insert!(db::MemoryDB_bubble, data::Dict{String,<:AbstractString})
    newnode = Node(Dict(k => String(v) for (k,v) in data))  # convert to plain String
    if db.head === nothing
        db.head = newnode
        return
    end
    temp = db.head
    while temp.next !== nothing
        temp = temp.next
    end
    temp.next = newnode
end




function insertion_sort!(db::MemoryDB_bubble, key::String)
    sorted_head = nothing
    current = db.head
    while current !== nothing
        nextnode = current.next
        if sorted_head === nothing || sorted_head.data[key] >= current.data[key]
            current.next = sorted_head
            sorted_head = current
        else
            temp = sorted_head
            while temp.next !== nothing && temp.next.data[key] < current.data[key]
                temp = temp.next
            end
            current.next = temp.next
            temp.next = current
        end
        current = nextnode
    end
    db.head = sorted_head
end

function exp(db::MemoryDB_bubble, filename::String)
    open(filename, "w") do io
        println(io, join(db.headers, ","))
        recurse(io, db.head, db.headers)
    end
end

function recurse(io, node::Union{Node, Nothing}, headers)
    if node === nothing
        return
    end
    row = [node.data[h] for h in headers]
    println(io, join(row, ","))
    recurse(io, node.next, headers)
end


db = MemoryDB_bubble()
get_data!(db, "student-data.csv")


println("Sorting by 'age' using Insertion Sort...")
insertion_sort!(db, "age")
exp(db, "sorted_22insertion.csv")
