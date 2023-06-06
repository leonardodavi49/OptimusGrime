class CleaningController < ApplicationController
  def instructions
    grid_size = params[:grid_size]
    coordinates = params[:coordinates]

    # Extracting the grid size
    grid_rows, grid_columns = grid_size.split("x").map(&:to_i)

    # Creating an empty grid
    grid = Array.new(grid_rows) { Array.new(grid_columns, " ") }

    # Marking the coordinates that need to be cleaned
    coordinates.each do |coordinate|
      x, y = coordinate.match(/\((\d+), (\d+)\)/).captures.map(&:to_i)
      grid[y][x] = "C"
    end

    # Generating the instructions to reach each coordinate
    instructions = ""
    current_x = 0
    current_y = 0

    coordinates.each do |coordinate|
      x, y = coordinate.match(/\((\d+), (\d+)\)/).captures.map(&:to_i)

      # Moving east or west
      if x > current_x
        instructions << "E" * (x - current_x)
      elsif x < current_x
        instructions << "W" * (current_x - x)
      end

      # Moving north or south
      if y > current_y
        instructions << "N" * (y - current_y)
      elsif y < current_y
        instructions << "S" * (current_y - y)
      end

      instructions << "C" # Cleaning the square-meter

      current_x = x
      current_y = y
    end

    render json: { instructions: instructions }
  end
end
