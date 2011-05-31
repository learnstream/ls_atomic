describe("YourMom", function() {
    it("is fat", function() {
      expect(YourMom.weight).toBeGreaterThan(500);
      });

    it("has a good error message", function() {  
      loadFixtures("order_form.html");  
      $("#card_number_error").text("Your mom is fat");
      expect($("#card_number_error")).toHaveText("Your mom is fat");
      });  
    });
