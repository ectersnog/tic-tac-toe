# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/tic_tac_toe/game'

RSpec.describe TicTacToe::Game do
  describe "creating a game" do
    context "when passed no parameters" do
      it "returns a default new game" do
        result = described_class.new
        expect(result).to be_a(described_class)
        expect(result.id).to be_a(String)
        expect(result.turn).to be("player")
        expect(result.player).to be("X")
        expect(result.computer).to be("O")
        expect(result.last_move_player).to be 0
        expect(result.last_move_computer).to be 0
        expect(result.status).to be("active")
        expect(result.winner).to be("")
        expect(result.token).to be_a(String)
      end
    end

    context "when passed player parameter" do
      it "allows player to play as O" do
        result = described_class.new(player: "O")
        expect(result.player).to be("O")
        expect(result.computer).to be("X")
      end

      it "defaults player to X given a non playable character" do
        result = described_class.new(player: "Q")
        expect(result.player).to be("X")
      end
    end

    context "when passed an id" do
      it "finds an already started game" do
        result1 = described_class.new
        result2 = described_class.new(id: result1.id, token: result1.token)
        expect(result1.id).to eq(result2.id)
        expect(result1.board).to eq(result2.board)
      end
    end
  end
end
