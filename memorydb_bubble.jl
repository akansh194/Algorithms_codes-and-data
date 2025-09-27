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


function bubble_sort!(db::MemoryDB_bubble, key::String)
    if db.head === nothing
        return
    end
    swapped = true
    while swapped
        swapped = false
        current = db.head
        while current !== nothing && current.next !== nothing
            if current.data[key] > current.next.data[key]
                current.data, current.next.data = current.next.data, current.data
                swapped = true
            end
            current = current.next
        end
    end
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

println("Sorting by 'age' using Bubble Sort...")
bubble_sort!(db, "age")
exp(db, "sorted_11bubble.csv")

