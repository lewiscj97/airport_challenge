require 'airport'

describe Airport do
  let(:plane) { double :plane }
  let(:subject) { Airport.new }
  
  describe "#land" do
    context "airport is not full" do
      it "lets a plane land at an airport" do
        allow(plane).to receive(:flying=) { :false }
        allow(plane).to receive(:flight_number) { "Flight 1" }
        expect(Weather).to receive(:rand).and_return(2)
        
        subject.land(plane)
        expect(subject.planes).to include "Flight 1"
      end
    end

    context "airport is full" do
      before(:each) do
        allow(plane).to receive(:flying=) { :false }
        allow(plane).to receive(:flying) { false }
      end

      it "prevents plane from landing when airport full to default capacity" do  
        20.times do
          expect(Weather).to receive(:rand).and_return(2)
          subject.land(plane)
        end

        twenty_first_plane = double(:twenty_first_plane)
        
        expect { subject.land(plane) }.to raise_error("Airport is full")
        expect(subject.planes).to_not include twenty_first_plane
      end

      it "prevents plane from landing when airport is full to a custom capacity" do
        capacity = 10
        
        airport = Airport.new(capacity)
        
        capacity.times do
          expect(Weather).to receive(:rand).and_return(2)
          airport.land(plane)
        end

        extra_plane = double(:extra_plane)

        expect { airport.land(plane) }.to raise_error("Airport is full")
        expect(airport.planes).to_not include extra_plane
      end
    end

    context "weather is stormy" do
      it "prevents a plane from landing when weather is stormy" do
        expect(Weather).to receive(:rand).and_return(8)
        expect { subject.land(plane) }.to raise_error("Cannot land a plane in stormy weather")
      end
    end
  end

  describe "#take_off" do

    before(:each) do
      allow(plane).to receive(:flying=) { :false }
      expect(Weather).to receive(:rand).and_return(2)
      subject.land(plane)
    end

    context "weather is not stormy" do
      before(:each) do
        expect(Weather).to receive(:rand).and_return(2)  
      end

      it "instructs a plane to take off" do
        expect(subject.take_off(plane)).to eq plane
      end
  
      it "plane is no longer in airport" do
        subject.take_off(plane)
        expect(subject.planes).to_not include plane
      end
  
      it "tells the plane that it is no longer landed" do
        subject.take_off(plane)
        allow(plane).to receive(:flying=) { :true }
        allow(plane).to receive(:flying) { true }
        expect(plane.flying).to eq true
      end  
    end
    
    context "weather is stormy" do
      it "doesn't let a plane take off" do
        expect(Weather).to receive(:rand).and_return(8)
        expect { subject.take_off(plane) }.to raise_error("Cannot take off in stormy weather")
      end
    end
  end
end
